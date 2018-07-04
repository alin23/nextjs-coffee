#!/usr/bin/env fish

gsutil -m rsync -r -x '.*\.DS_Store|.+\.styl$|.*/test\..+' static gs://static.domain.tld
gsutil -m acl ch -r -u AllUsers:R gs://static.domain.tld