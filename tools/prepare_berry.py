"""Fix the pinned host compiler's debug-buffer overflow without hiding warnings."""
from pathlib import Path
path = Path('.berry/src/be_debug.c')
source = path.read_text()
old = '''    memcpy(__lbuf_tmp, __lbuf, strlen(__lbuf) + 1);
    logbuf("%s\\n", __lbuf_tmp);
    if (fout) {
        be_fwrite(fout, __lbuf, strlen(__lbuf));
    } else {
        be_writestring(__lbuf);
    }'''
new = '''    if (fout) {
        be_fwrite(fout, __lbuf, strlen(__lbuf));
        be_fwrite(fout, "\\n", 1);
    } else {
        be_writestring(__lbuf);
        be_writestring("\\n");
    }'''
assert source.count(old) == 1, 'Pinned Berry debug implementation changed'
source = source.replace(old, new).replace('char __lbuf[INST_BUF_SIZE + 1], __lbuf_tmp[INST_BUF_SIZE];', 'char __lbuf[INST_BUF_SIZE + 1];')
path.write_text(source)
path = Path('.berry/src/be_byteslib.c')
source = path.read_text()
old = 'ret_f = *(float*) &ret_i;'
assert source.count(old) == 1, 'Pinned Berry float reader changed'
path.write_text(source.replace(old, 'memcpy(&ret_f, &ret_i, sizeof(ret_f));'))
