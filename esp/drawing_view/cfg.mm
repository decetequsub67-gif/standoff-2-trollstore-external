#import "cfg.h"
#import "tt.h"
#include "obfusheader.h"

extern volatile bool esp_screenshot_safe;

NSString *cfg_get_dir() {
    NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *confDir = [docs stringByAppendingPathComponent:@(OBF("eztapp"))];
    [[NSFileManager defaultManager] createDirectoryAtPath:confDir withIntermediateDirectories:YES attributes:nil error:nil];
    return confDir;
}

NSArray<NSString*> *cfg_get_list() {
    NSString *confDir = cfg_get_dir();
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:confDir error:nil];
    NSMutableArray *configs = [NSMutableArray array];
    for (NSString *f in files) {
        if ([f hasSuffix:@(OBF(".plist"))]) {
            [configs addObject:[f stringByDeletingPathExtension]];
        }
    }
    return configs;
}

void cfg_create(NSString *name) {
    if (name.length == 0) return;
    NSString *path = [cfg_get_dir() stringByAppendingPathComponent:[NSString stringWithFormat:@(OBF("%@.plist")), name]];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@(OBF("esp_box_enabled"))] = @(esp_box_enabled);
    dict[@(OBF("esp_box_outline"))] = @(esp_box_outline);
    dict[@(OBF("esp_box_fill"))] = @(esp_box_fill);
    dict[@(OBF("esp_box_corner"))] = @(esp_box_corner);
    dict[@(OBF("esp_box_3d"))] = @(esp_box_3d);
    dict[@(OBF("esp_line_enabled"))] = @(esp_line_enabled);
    dict[@(OBF("esp_line_outline"))] = @(esp_line_outline);
    dict[@(OBF("esp_invisible"))] = @(esp_invisible);
    dict[@(OBF("esp_addscore"))] = @(esp_addscore);
    dict[@(OBF("esp_inf_ammo"))] = @(esp_inf_ammo);
    dict[@(OBF("esp_no_spread"))] = @(esp_no_spread);
    dict[@(OBF("esp_air_jump"))] = @(esp_air_jump);
    dict[@(OBF("esp_fast_knife"))] = @(esp_fast_knife);
    dict[@(OBF("esp_bunny_hop"))] = @(esp_bunny_hop);
    dict[@(OBF("esp_wallshot"))] = @(esp_wallshot);
    dict[@(OBF("esp_fire_rate"))] = @(esp_fire_rate);
    dict[@(OBF("esp_team_check"))] = @(esp_team_check);
    
    dict[@(OBF("aimbot_enabled"))] = @(aimbot_enabled);
    dict[@(OBF("aimbot_visible_check"))] = @(aimbot_visible_check);
    dict[@(OBF("aimbot_shooting_check"))] = @(aimbot_shooting_check);
    dict[@(OBF("aimbot_knife_bot"))] = @(aimbot_knife_bot);
    dict[@(OBF("aimbot_smooth"))] = @(aimbot_smooth);
    dict[@(OBF("aimbot_trigger_delay"))] = @(aimbot_trigger_delay);
    dict[@(OBF("aimbot_bone_index"))] = @(aimbot_bone_index);
    
    dict[@(OBF("esp_rcs_enabled"))] = @(esp_rcs_enabled);
    dict[@(OBF("esp_rcs_h"))] = @(esp_rcs_h);
    dict[@(OBF("esp_rcs_v"))] = @(esp_rcs_v);
    
    dict[@(OBF("esp_bhop_setting"))] = @(esp_bhop_setting);
    dict[@(OBF("aimbot_triggerbot"))] = @(aimbot_triggerbot);
    dict[@(OBF("aimbot_fov_visible"))] = @(aimbot_fov_visible);
    dict[@(OBF("aimbot_fov"))] = @(aimbot_fov);
    dict[@(OBF("aimbot_team_check"))] = @(aimbot_team_check);
    dict[@(OBF("esp_name_enabled"))] = @(esp_name_enabled);
    dict[@(OBF("esp_name_outline"))] = @(esp_name_outline);
    dict[@(OBF("esp_health_enabled"))] = @(esp_health_enabled);
    dict[@(OBF("esp_health_bar_enabled"))] = @(esp_health_bar_enabled);
    dict[@(OBF("esp_health_bar_outline"))] = @(esp_health_bar_outline);
    dict[@(OBF("esp_weapon_enabled"))] = @(esp_weapon_enabled);
    dict[@(OBF("esp_weapon_icon_enabled"))] = @(esp_weapon_icon_enabled);
    dict[@(OBF("esp_platform_enabled"))] = @(esp_platform_enabled);
    dict[@(OBF("esp_avatar_enabled"))] = @(esp_avatar_enabled);
    
    dict[@(OBF("viewmodel_enabled"))] = @(viewmodel_enabled);
    dict[@(OBF("viewmodel_x"))] = @(viewmodel_x);
    dict[@(OBF("viewmodel_y"))] = @(viewmodel_y);
    dict[@(OBF("viewmodel_z"))] = @(viewmodel_z);

    dict[@(OBF("esp_auto_load"))] = @(esp_auto_load);
    dict[@(OBF("esp_screenshot_safe"))] = @(esp_screenshot_safe);

    [dict writeToFile:path atomically:YES];
}

void cfg_load(NSString *name) {
    if (name.length == 0) return;
    NSString *path = [cfg_get_dir() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", name]];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    if (!dict) return;
    
    if (dict[@(OBF("esp_box_enabled"))]) esp_box_enabled = [dict[@(OBF("esp_box_enabled"))] boolValue];
    if (dict[@(OBF("esp_box_outline"))]) esp_box_outline = [dict[@(OBF("esp_box_outline"))] boolValue];
    if (dict[@(OBF("esp_box_fill"))]) esp_box_fill = [dict[@(OBF("esp_box_fill"))] boolValue];
    if (dict[@(OBF("esp_box_corner"))]) esp_box_corner = [dict[@(OBF("esp_box_corner"))] boolValue];
    if (dict[@(OBF("esp_box_3d"))]) esp_box_3d = [dict[@(OBF("esp_box_3d"))] boolValue];
    if (dict[@(OBF("esp_line_enabled"))]) esp_line_enabled = [dict[@(OBF("esp_line_enabled"))] boolValue];
    if (dict[@(OBF("esp_line_outline"))]) esp_line_outline = [dict[@(OBF("esp_line_outline"))] boolValue];
    if (dict[@(OBF("esp_invisible"))]) esp_invisible = [dict[@(OBF("esp_invisible"))] boolValue];
    if (dict[@(OBF("esp_addscore"))]) esp_addscore = [dict[@(OBF("esp_addscore"))] boolValue];
    if (dict[@(OBF("esp_inf_ammo"))]) esp_inf_ammo = [dict[@(OBF("esp_inf_ammo"))] boolValue];
    if (dict[@(OBF("esp_no_spread"))]) esp_no_spread = [dict[@(OBF("esp_no_spread"))] boolValue];
    if (dict[@(OBF("esp_air_jump"))]) esp_air_jump = [dict[@(OBF("esp_air_jump"))] boolValue];
    if (dict[@(OBF("esp_fast_knife"))]) esp_fast_knife = [dict[@(OBF("esp_fast_knife"))] boolValue];
    if (dict[@(OBF("esp_bunny_hop"))]) esp_bunny_hop = [dict[@(OBF("esp_bunny_hop"))] boolValue];
    if (dict[@(OBF("esp_wallshot"))]) esp_wallshot = [dict[@(OBF("esp_wallshot"))] boolValue];
    if (dict[@(OBF("esp_fire_rate"))]) esp_fire_rate = [dict[@(OBF("esp_fire_rate"))] boolValue];
    if (dict[@(OBF("esp_team_check"))]) esp_team_check = [dict[@(OBF("esp_team_check"))] boolValue];
    
    if (dict[@(OBF("aimbot_enabled"))]) aimbot_enabled = [dict[@(OBF("aimbot_enabled"))] boolValue];
    if (dict[@(OBF("aimbot_visible_check"))]) aimbot_visible_check = [dict[@(OBF("aimbot_visible_check"))] boolValue];
    if (dict[@(OBF("aimbot_shooting_check"))]) aimbot_shooting_check = [dict[@(OBF("aimbot_shooting_check"))] boolValue];
    if (dict[@(OBF("aimbot_knife_bot"))]) aimbot_knife_bot = [dict[@(OBF("aimbot_knife_bot"))] boolValue];
    if (dict[@(OBF("aimbot_smooth"))]) aimbot_smooth = [dict[@(OBF("aimbot_smooth"))] floatValue];
    if (dict[@(OBF("aimbot_trigger_delay"))]) aimbot_trigger_delay = [dict[@(OBF("aimbot_trigger_delay"))] floatValue];
    if (dict[@(OBF("aimbot_bone_index"))]) aimbot_bone_index = [dict[@(OBF("aimbot_bone_index"))] intValue];
    
    if (dict[@(OBF("esp_rcs_enabled"))]) esp_rcs_enabled = [dict[@(OBF("esp_rcs_enabled"))] boolValue];
    if (dict[@(OBF("esp_rcs_h"))]) esp_rcs_h = [dict[@(OBF("esp_rcs_h"))] floatValue];
    if (dict[@(OBF("esp_rcs_v"))]) esp_rcs_v = [dict[@(OBF("esp_rcs_v"))] floatValue];
    
    if (dict[@(OBF("esp_bhop_setting"))]) esp_bhop_setting = [dict[@(OBF("esp_bhop_setting"))] intValue];
    if (dict[@(OBF("aimbot_triggerbot"))]) aimbot_triggerbot = [dict[@(OBF("aimbot_triggerbot"))] boolValue];
    if (dict[@(OBF("aimbot_fov_visible"))]) aimbot_fov_visible = [dict[@(OBF("aimbot_fov_visible"))] boolValue];
    if (dict[@(OBF("aimbot_fov"))]) aimbot_fov = [dict[@(OBF("aimbot_fov"))] floatValue];
    if (dict[@(OBF("aimbot_team_check"))]) aimbot_team_check = [dict[@(OBF("aimbot_team_check"))] boolValue];
    if (dict[@(OBF("esp_name_enabled"))]) esp_name_enabled = [dict[@(OBF("esp_name_enabled"))] boolValue];
    if (dict[@(OBF("esp_name_outline"))]) esp_name_outline = [dict[@(OBF("esp_name_outline"))] boolValue];
    if (dict[@(OBF("esp_health_enabled"))]) esp_health_enabled = [dict[@(OBF("esp_health_enabled"))] boolValue];
    if (dict[@(OBF("esp_health_bar_enabled"))]) esp_health_bar_enabled = [dict[@(OBF("esp_health_bar_enabled"))] boolValue];
    if (dict[@(OBF("esp_health_bar_outline"))]) esp_health_bar_outline = [dict[@(OBF("esp_health_bar_outline"))] boolValue];
    if (dict[@(OBF("esp_weapon_enabled"))]) esp_weapon_enabled = [dict[@(OBF("esp_weapon_enabled"))] boolValue];
    if (dict[@(OBF("esp_weapon_icon_enabled"))]) esp_weapon_icon_enabled = [dict[@(OBF("esp_weapon_icon_enabled"))] boolValue];
    if (dict[@(OBF("esp_platform_enabled"))]) esp_platform_enabled = [dict[@(OBF("esp_platform_enabled"))] boolValue];
    if (dict[@(OBF("esp_avatar_enabled"))]) esp_avatar_enabled = [dict[@(OBF("esp_avatar_enabled"))] boolValue];
    
    if (dict[@(OBF("viewmodel_enabled"))]) viewmodel_enabled = [dict[@(OBF("viewmodel_enabled"))] boolValue];
    if (dict[@(OBF("viewmodel_x"))]) viewmodel_x = [dict[@(OBF("viewmodel_x"))] floatValue];
    if (dict[@(OBF("viewmodel_y"))]) viewmodel_y = [dict[@(OBF("viewmodel_y"))] floatValue];
    if (dict[@(OBF("viewmodel_z"))]) viewmodel_z = [dict[@(OBF("viewmodel_z"))] floatValue];
    
    if (dict[@(OBF("esp_auto_load"))]) esp_auto_load = [dict[@(OBF("esp_auto_load"))] boolValue];
    if (dict[@(OBF("esp_screenshot_safe"))]) esp_screenshot_safe = [dict[@(OBF("esp_screenshot_safe"))] boolValue];
}

void cfg_delete(NSString *name) {
    if (name.length == 0) return;
    NSString *path = [cfg_get_dir() stringByAppendingPathComponent:[NSString stringWithFormat:@(OBF("%@.plist")), name]];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}
