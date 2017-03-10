FROM quentinv/cmdbuild:latest


ENV NOTVISIBLE "in users profile"
ENV PGPASSFILE "/root/.pgpass.conf"

RUN 	echo	 							\
   	'deb ftp://ftp.fr.debian.org/debian/ jessie main\n 		\
       	deb ftp://ftp.fr.debian.org/debian/ jessie-updates main\n 	\
        deb http://security.debian.org jessie/updates main\n' 		\
	> /etc/apt/sources.list 					\
	&& apt-get update 						\
	&& apt-get install -y openssh-server postgresql-client 	netcat	\
	&& mkdir /var/run/sshd						\
	&& echo 'root:root' | chpasswd					\
	&& sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config		\
	&& sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd	\
	&& echo "export VISIBLE=now" >> /etc/profile



EXPOSE 22

ADD ./pgpass.conf /root/.pgpass.conf
ADD ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

WORKDIR /

CMD ["catalina.sh", "run"]
