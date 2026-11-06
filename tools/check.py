from pathlib import Path
import re
root=Path(__file__).resolve().parents[1]
for script in root.glob('*.be'):
    for name in re.findall(r'load\("([^"]+)"\)',script.read_text()):
        assert (root/name).is_file(),f'{script.name} loads missing {name}'
assert {'autoexec.be','tasmota.be','txultimate.be'} <= {p.name for p in root.glob('*.be')}
print('Boot script dependencies are complete')
