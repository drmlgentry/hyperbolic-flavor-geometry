with open(r'papers/regulator-lattice/gentry-regulator-lattice.tex', 'rb') as f:
    raw = f.read()
# The file has literal backslash-backslash-n sequences
# Replace \\\\n (two chars: backslash + n) with actual newline
# Replace \\\\\\\\ (two backslashes) with single backslash
import re
# First fix newlines
raw = raw.replace(b'\\\\n', b'\\n')
# Then fix doubled backslashes
raw = raw.replace(b'\\\\\\\\', b'\\\\')
with open(r'papers/regulator-lattice/gentry-regulator-lattice.tex', 'wb') as f:
    f.write(raw)
# Verify
t = open(r'papers/regulator-lattice/gentry-regulator-lattice.tex', encoding='utf-8').read()
print('lines:', t.count('\\n'))
print('first 80:', repr(t[:80]))
