#!/bin/bash -e
# vim:set ai si sts=2 sw=2 et:
# start with -f to force page rebuild

# can be started from sub-directory
cd "$(dirname "$(which "$0")")"

DATE=$(date -u --iso=sec)

echo -e "\033[0;32mOutstanding draft pages...\033[0m"
hugo list drafts

# git config advice.addIgnoredFile false
git add -A -- * || true

if git diff --cached --exit-code >/dev/null ; then
  echo -e "\033[0;31mSource not changed from the last commit\033[0m"
else
  echo -e "\033[0;32mSource changed from the last commit\033[0m"
  git commit -a -m "source updated: $DATE"
fi

# Ensure to kill previous hugo
killall hugo || true
echo -e "\033[0;32mStarting web page at http://localhost:8080\033[0m"
systemd-cat -t hugo -p 6 hugo server -p 8080 --disableFastRender &
echo -e "\033[0;32mRead log with 'journalctrl -f'\033[0m"
