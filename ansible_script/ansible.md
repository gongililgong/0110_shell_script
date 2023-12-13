# Ansible Script

해당 스크립트는 기본적으로 AWX에서 사용하는것을 전제로 만들었습니다.

왜냐면 제가 AWX 를 사용하기에 그렇습니다.

여러분들도 이 스크립트를 playbook으로 돌리기 보단 UI를 통해 쉽게 적용 해보시길 바랍니다.

설치 관련은 제 블로그를 통해 봐주시면 감사합니다.

상황에 따라서 쓰고싶은 구문이 있고 없으니 맘대로 갖다 붙여서 사용하시면 됩니다.

remote_user 는 sudo 권한이 있어야 합니다.

만약 AWX를 설치하지 않고 사용하고 싶으시다면 

ubuntu_infra_setting.yml 과 같은 레벨의 디렉토리에

extra_vars.yml 파일을 하나 만들어서

---

#vm 이름
hosts: 
- yj-infra-test-vm

ansible_port: 입력

remote_user:  입력

disk_name: 입력

disk_scsi: 입력

mount_point: 입력

pubkey: 입력

만들어서 사용하시면 됩니다.

이정도 커스텀하실줄 아신다면... ansible 변수 스크립트 적용하는건 하실줄 아시리라 믿습니다.