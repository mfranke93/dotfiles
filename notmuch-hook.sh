#!/bin/sh
notmuch new
# tag all messages from "me" as sent and remove tags inbox and unread
notmuch tag -new -inbox +sent -- from:sniff@mumintroll.org or from:max@mumintroll.org
