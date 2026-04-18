#import "unity.h"

struct c_matrix_new {
    float m[4][4];
};

Vector3 get_position_by_transform(mach_vm_address_t mach_transform_ptr, task_t task)
{
    mach_vm_address_t transObj = Read<mach_vm_address_t>(mach_transform_ptr + 0x10, task);
    if (!transObj) return Vector3{0,0,0};

    mach_vm_address_t matrix = Read<mach_vm_address_t>(transObj + 0x38, task);
    if (!matrix) return Vector3{0,0,0};

    int index = Read<int>(transObj + 0x40, task);

    mach_vm_address_t matrix_list = Read<mach_vm_address_t>(matrix + 0x18, task);
    mach_vm_address_t matrix_indices = Read<mach_vm_address_t>(matrix + 0x20, task);
    if (!matrix_list || !matrix_indices) return Vector3{0,0,0};

    Vector3 result = Read<Vector3>(matrix_list + (size_t)sizeof(TMatrix) * (size_t)index, task);
    int transformIndex = Read<int>(matrix_indices + (size_t)sizeof(int) * (size_t)index, task);

    if (transformIndex < 0) return result;

    int max_safety = 50;
    while (transformIndex >= 0 && max_safety-- > 0)
    {
        TMatrix tMatrix = Read<TMatrix>(matrix_list + (size_t)sizeof(TMatrix) * (size_t)transformIndex, task);

        float rotX = tMatrix.rotation.x;
        float rotY = tMatrix.rotation.y;
        float rotZ = tMatrix.rotation.z;
        float rotW = tMatrix.rotation.w;

        float scaleX = result.x * tMatrix.scale.x;
        float scaleY = result.y * tMatrix.scale.y;
        float scaleZ = result.z * tMatrix.scale.z;

        result.x = tMatrix.position.x + scaleX +
            (scaleX * ((rotY * rotY * -2.0f) - (rotZ * rotZ * 2.0f))) +
            (scaleY * ((rotW * rotZ * -2.0f) - (rotY * rotX * -2.0f))) +
            (scaleZ * ((rotZ * rotX * 2.0f) - (rotW * rotY * -2.0f)));
        result.y = tMatrix.position.y + scaleY +
            (scaleX * ((rotX * rotY * 2.0f) - (rotW * rotZ * -2.0f))) +
            (scaleY * ((rotZ * rotZ * -2.0f) - (rotX * rotX * 2.0f))) +
            (scaleZ * ((rotW * rotX * -2.0f) - (rotZ * rotY * -2.0f)));
        result.z = tMatrix.position.z + scaleZ +
            (scaleX * ((rotW * rotY * -2.0f) - (rotX * rotZ * -2.0f))) +
            (scaleY * ((rotY * rotZ * 2.0f) - (rotW * rotX * -2.0f))) +
            (scaleZ * ((rotX * rotX * -2.0f) - (rotY * rotY * 2.0f)));

        transformIndex = Read<int>(matrix_indices + (size_t)sizeof(int) * (size_t)transformIndex, task);
    }

    return result;
}

Vector3 WorldToScreen(Vector3 object, SO2_Matrix mat, CGFloat ScreenWidth, CGFloat ScreenHeight)
{

    float screenX = (mat.m11 * object.x) + (mat.m21 * object.y) + (mat.m31 * object.z) + mat.m41;
    float screenY = (mat.m12 * object.x) + (mat.m22 * object.y) + (mat.m32 * object.z) + mat.m42;
    float screenW = (mat.m14 * object.x) + (mat.m24 * object.y) + (mat.m34 * object.z) + mat.m44;

    Vector3 result;
    if(screenW < 0.0001f) {
        result.z = -1;
        return result;
    }

    float camX = ScreenWidth / 2.0f;
    float camY = ScreenHeight / 2.0f;
    result.x = camX + (camX * screenX / screenW);
    result.y = camY - (camY * screenY / screenW);
    result.z = screenW;
    return result;
}