#!/bin/bash

/usr/sbin/sshd

# Wait until PostgreSQL ready.
while ! nc -z postgresql 5432; do sleep 3; done

pwd
ls -la /usr/local
ls -la /usr/local/tomcat
ls -la /usr/local/tomcat/webapps
ls -la /usr/local/tomcat/webapps/ROOT

# Base schema.
cd /usr/local/tomcat/webapps/ROOT/WEB-INF/sql/base_schema
for i in `ls`; do psql -h postgresql -p 5432 -U cmdbuild -f $i cmdbuild; done

# Shark schema.
cd /usr/local/tomcat/webapps/ROOT/WEB-INF/sql/shark_schema
for i in `ls`; do psql -h postgresql -p 5432 -U cmdbuild -f $i cmdbuild; done

# Patching.
cat > /root/script.sql << "EOF"
SELECT cm_create_class('Patch', 'Class', 'DESCR: |MODE: reserved|STATUS: active|SUPERCLASS: false|TYPE: class');

INSERT INTO "Patch" ("Code") VALUES ('2.4.2-02');


INSERT INTO "User" ("Status", "Username", "IdClass", "Password", "Description") VALUES ('A', 'admin', '"User"', 'DQdKW32Mlms=', 'Administrator');
INSERT INTO "Role" ("Status", "IdClass", "Administrator", "Code", "Description") VALUES ('A', '"Role"', true, 'SuperUser', 'SuperUser');
INSERT INTO "Map_UserRole" ("Status", "IdClass1", "IdClass2", "IdObj1", "IdObj2", "IdDomain") VALUES ('A', '"User"'::regclass,'"Role"'::regclass, currval('class_seq')-2, currval('class_seq'), '"Map_UserRole"'::regclass);
EOF

psql -h postgresql -p 5432 -U cmdbuild -f /root/script.sql

exec "$@"
