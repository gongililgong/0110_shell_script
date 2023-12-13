# 앤서블 Role

이 스크립트는 ansible role 기능으로 작성되었으며 nginx를 docker-compose로 기동시킵니다.

어느 github 에서 nginx docker를 centos7 에 적용시키는것에 영감을 받아 Redhat 과 ubuntu 상관없이 만들수 있는 버전으로 만들었습니다.

ansible role 커스텀을 원하신다면 ansible role 작성법에 대해 알아보시면 될것 같습니다.

nginx-docker-compose 를 하기 위해서 여러개의 playbook과 설정파일들이 필요로 하기에 가장 효율적으로 쓸수 있는것이 무엇이 있을까 고민해 보다가 terraform module 처럼 재작성이 가능한 기능이 role 기능이었습니다.

그래서 쓰기로 결심 했습니다.


---

# 사용 방법

#### 1. 해당 스크립트는 443 port 및 domain이 적용 되어 있습니다. 그러므로 SSL 인증서가 필수로 있어야 정상적으로 배포가 됩니다. 

#### 2. 인증서 업로드 경로 = roles/nginx/templates

  -  인증서 이름은 기본 key.pem , cert.pem  (이름 변경 경로 : defaluts/main.yml )

#### 3. proxy_pass 처리 (백엔드 포트 미처리시 주석 하여 사용)

#### 4. 80 포트 전용 nginx script -> ansible-nginx-docker-compose-not-ssl 사용바람

---

# 폴더별 설명

- roles

    - nginx -> role에서 불러온 nginx 폴더

        - defaults -> role 기본값들을 저장 (뼈대라고 보면 됩니다.)

        - files -> 504 혹은 index 페이지를 담는 폴더

        - handlers -> docker container docker daemon이나 서버가 죽고 다시 살아났을때 자동으로 container 
        기동시켜주는 폴더 (tasks/main.yml 에서 notify 주석 해제시 실행된다.)

        - tasks -> docker-compose 가 돌아가기 위해 서버에 폴더와 nginx 구성을 만드는 폴더 (이 곳이 실제 동작할 내용이라고 보시면 됩니다.)
 
        - tempates -> 각종 필요한 파일들을 템플릿화하여 담은 공간
 
        - vars -> Ansible EXTRA_VARS에 사용할 변수를 미리 넣어놓음

자세한 것은 각 파일별로 주석처리하여 설명해놨으니 보면서 참고 하시길 바랍니다.

AWX에서 쓰기 위해선 EXTRA_VARS 를 다음과 같이 집어넣으시면 됩니다.

---

# Ansible EXTRA_VARS 작성 내용

hosts: 
  \- 호스트네임 입력

ansible_os_family: Ubuntu #or Redhat(centos 도 Redhat 으로 쓰면됨)

domain_select: domain.com

ansible_port: 입력

remote_user: 입력

nginx_base_directory: "/home/\[user\]/nginx"

docker_network_name: "docker_network"

backends_ip: {"IP:PORT"}

hostdomain_name: subdomain.domain.com

backend_name:프록시 패스 백엔드 네임 지정

conf_name : conf파일 입력

---

