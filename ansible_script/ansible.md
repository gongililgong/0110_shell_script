# Ansible Script

제작자 : 공일일공

AWX 용 스크립트, Ansible로 사용하고자 할땐 EXTRA_VARS를 따로 정하기

AWX 설치 관련은 제 블로그를 통해 봐주시면 감사합니다.

remote_user 는 sudo 권한이 있어야 합니다.

만약 AWX를 설치하지 않고 사용하고 싶으시다면 ubuntu_infra_setting.yml 과 같은 레벨의 디렉토리에

extra_vars.yml 파일을 아래와 같이 하나 만들어서 사용하시면 됩니다.


#vm 이름

hosts: 

\- yj-infra-test-vm

ansible_port: 입력

remote_user:  입력

disk_name: 입력

disk_scsi: 입력

mount_point: 입력

pubkey: 입력

---

#### 이정도 커스텀하실줄 아신다면... ansible 변수 스크립트 적용하는건 하실줄 아시리라 믿습니다.

---

# CREATE-VM.yml

VM을 생성하는 스크립트입니다.

기본적으로 resource_group, vnet , subnet , NSG , VM 을 만듭니다.

---

# DELETE-VM.yml

VM을 삭제하는 스크립트입니다.

삭제에는 의존성이 있기에 역순으로 가장 하위부터 지워나가야 하기에 create-vm.yml을 역순으로 작성 후 

state : absent 를 넣어 삭제 진행합니다.

# ANSIBLE-NGINX-DOCKER-COMPOSE

ansible 스크립트로 nginx를 docker-compose로 생성하여 서비스 기동 시키는 스크립트 입니다.

해당 스크립트는 SSL 인증서가 필수로 있어야 정상적으로 기동 됩니다.

# ANSIBLE-NGINX-DOCKER-COMPOSE-NOT-SSL

ansible 스크립트로 nginx를 docker-compose로 생성하여 서비스 기동 시키는 스크립트 입니다.

해당 스크립트는 SSL 인증서없어도 80 port로 정상적으로 기동 됩니다.

# UBUNTU_INFRA_SETTING

 UBUNTU 인프라 환경 구성을 해주는 스크립트입니다.

 상세 적용은 스크립트를 통해 확인하시길 바랍니다.
