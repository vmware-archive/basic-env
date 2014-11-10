#!/bin/bash

eval `next_file_named -f out` > /dev/null

cat<<-EOF > $o
#!/bin/bash
echo -e 'c1oudc0w\n' | sudo -S  -s "$*"
EOF


echo "Commands:"
echo "  $*"
echo "  written to $o"
