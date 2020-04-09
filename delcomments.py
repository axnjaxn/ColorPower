import sys, re

if len(sys.argv) != 2:
    print('Usage: python %s input-filename.p8' % (sys.argv[0]))
    sys.exit()

lines = []
allow = False
with open(sys.argv[1], 'r') as fp:
    for line in fp:
        if '-->8' in line or line == "__lua__":
            allow = True
        elif '--' in line and not '---' in line:
            if not allow:
                line = line.split('--')[0] + '\n'
                if line == '\n': continue
        else:
            allow = False
        lines.append(line)
        
with open(sys.argv[1], 'w') as fp:
    for line in lines:
        fp.write(line)
