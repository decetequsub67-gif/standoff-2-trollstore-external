import os
import json
import re

def find_skins(dump):
    pat = re.compile(r"public enum (\w+)[^{]*\{((?:.|\n)*?)\}", re.DOTALL)
    for m in re.finditer(pat, dump):
        body = m.group(2)
        if "MedalAssistanceBronze" not in body:
            continue
        consts = re.findall(r"([A-Za-z0-9_]+)\s*=\s*([0-9]+)", body)
        if not consts:
            continue
        return [{"skiname": n.strip(), "id": int(v)} for n, v in consts]
    return []
def get_fields(dump, cls):
    pat = r"(?:public class |public static class )" + re.escape(cls) + r".*?\{{(.*?)\n\}}"
    m = re.search(pat, dump, re.DOTALL)
    if not m:
        return []
    fields = re.findall(
        r"(public|private|protected).*? ([A-Za-z0-9_<>,\[\]\?]+) ([A-Za-z0-9_<>]+);\s*// (0x[0-9A-Fa-f]+)",
        m.group(1)
    )
    return [{"name": fn, "type": ft, "offset": off} for _, ft, fn, off in fields]
def save_controller(dump, cls):
    data = get_fields(dump, cls)
    if not data:
        return
    os.makedirs("dump/controllers", exist_ok=True)
    with open(f"dump/controllers/{cls}.json", "w", encoding="utf-8") as f:
        json.dump(data, f, indent=4, ensure_ascii=False)
def find_inventory_cls(dump):
    pat = re.compile(r"internal class (\w+)\s*:[^\{]+\{((?:.|\n)*?)\n\}", re.DOTALL)
    for m in re.finditer(pat, dump):
        body = m.group(2)
        if "private readonly SemaphoreSlim" not in body:
            continue
        if len(re.findall(r"// 0x[0-9A-Fa-f]+", body)) >= 12:
            return m.group(1)
    return None
def find_bolt_inventory_cls(dump):
    pat = re.compile(r"internal class (\w+)\s*:[^\{]+\{((?:.|\n)*?)\n\}", re.DOTALL)
    for m in re.finditer(pat, dump):
        body = m.group(2)
        if "internal static SemaphoreSlim" not in body:
            continue
        if "GetInventoryItemDefinitionsResponse" not in body:
            continue
        return m.group(1)
    return None
def find_static_cls(dump):
    pat = re.compile(r"public static class (\w+)(?:[^\{]+)?\{((?:.|\n)*?)\n\}", re.DOTALL)
    for m in re.finditer(pat, dump):
        body = m.group(2)
        if len(re.findall(r"// 0x[0-9A-Fa-f]+", body)) >= 11:
            return m.group(1)
    return None
def search_script(targets, name_map):
    if not os.path.exists("script.json"):
        return
    try:
        with open("script.json", "r", encoding="utf-8") as f:
            raw = f.read()
    except Exception:
        return
    found = {}
    for t in targets:
        tname = t["name"]
        tsig = t["sig"]
        obf_key = tname.split("_TypeInfo")[0]
        real_name = name_map.get(obf_key)
        is_obf = real_name is not None
        p = re.compile(
            r'\{\s*"Address":\s*(\d+),\s*"Name":\s*"' + re.escape(tname) + r'",\s*"Signature":\s*"([^"]+)"\s*\}',
            re.IGNORECASE
        )
        m = p.search(raw)
        if m:
            key = real_name if is_obf else tname
            if key not in found:
                found[key] = {"Address": int(m.group(1)), "Name": key, "Signature": m.group(2)}
            continue
        if not is_obf:
            sig_pat = re.compile(
                r'\{\s*"Address":\s*(\d+),\s*"Name":\s*"([^"]+)",\s*"Signature":\s*"' + re.escape(tsig.replace("*", "")) + r'[^"]*"\s*\}',
                re.IGNORECASE
            )
            m2 = sig_pat.search(raw)
            if m2:
                sig = re.search(r'"Signature":\s*"([^"]+)"', m2.group(0), re.IGNORECASE).group(1)
                key = m2.group(2).split(".")[-1]
                if key not in found:
                    found[key] = {"Address": int(m2.group(1)), "Name": key, "Signature": sig}
        else:
            if tname not in found:
                found[tname] = {"Address": 0, "Name": tname, "Signature": tsig}
    os.makedirs("dump", exist_ok=True)
    with open("dump/type_info.json", "w", encoding="utf-8") as f:
        json.dump(found, f, indent=4, ensure_ascii=False)
def main():
    if not os.path.exists("dump.cs"):
        return
    with open("dump.cs", "r", encoding="utf-8", errors="ignore") as f:
        dump = f.read()
    os.makedirs("dump", exist_ok=True)
    with open("dump/skins.json", "w", encoding="utf-8") as f:
        json.dump(find_skins(dump), f, indent=4, ensure_ascii=False)
    for cls in ["PlayerController", "MecanimController", "WeaponryController", "MovementController"]:
        save_controller(dump, cls)
    inv_cls = find_inventory_cls(dump)
    bolt_cls = find_bolt_inventory_cls(dump)
    static_cls = find_static_cls(dump)
    targets = [
        {"name": "Axlebolt.Standoff.Player.PlayerManager_TypeInfo", "sig": "Axlebolt_Standoff_Player_PlayerManager_c*"},
        {"name": "Axlebolt.Standoff.Game.GameController_TypeInfo", "sig": "Axlebolt_Standoff_Game_GameController_c*"},
        {"name": "Axlebolt.Standoff.Inventory.Bomb.BombManager_TypeInfo", "sig": "Axlebolt_Standoff_Inventory_Bomb_BombManager_c*"},
    ]
    name_map = {}
    if inv_cls:
        targets.append({"name": inv_cls + "_TypeInfo", "sig": inv_cls + "_c*"})
        name_map[inv_cls] = "BoltInvenoryService"
    if bolt_cls:
        targets.append({"name": bolt_cls + "_TypeInfo", "sig": bolt_cls + "_c*"})
        name_map[bolt_cls] = "BoltInventory"
    if static_cls:
        targets.append({"name": static_cls + "_TypeInfo", "sig": static_cls + "_c*"})
        name_map[static_cls] = "Static"
    search_script(targets, name_map)
if __name__ == "__main__":
    main()
    print("скрипт от ебаната алогена @ologen , @fimozroot")
