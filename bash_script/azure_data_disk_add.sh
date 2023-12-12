#!/bin/bash
# 만든이 : 01110
# 제작일자 : 2023-01
DISK_NAME=sd #이 부분으로 sd* 부분 출력 tip) Ansible Script 에 넣으려면 중괄호 두번쳐서 쓰기
DISK_SCSI=/dev/disk/azure/scsi1
DIRECTORY_MOUNT=(  
/data3 /data4
)
# 데이터 디스크 리스트를추출한다
#만약 Azure 용이 아니라면 /dev/disk/azure -> 이부분이 다르게 들어갈듯?
data_disk_list=$(ls -l ${DISK_SCSI}|grep -i "${DISK_NAME}" |awk '{print $11}'| sed 's/\(\.\.\/\)//g')

# parted 할때 device를 찾아야하는데 이 과정에서 필요하다
parent_data_disk_array=() # 디스크 상위 계층 sdc sdd... 배열 저장용
child_data_disk_array=()  # 디스크 하위 계층 sdc1 sdd1.... 배열 저장용

# for문이 돌때마다 배열에 0 번째 1번째 ... 자리에 data_disk_list 를 돌린다
# 돌린 후 나온 디스크 배열들을 parted 하여 포맷한다.
for i in ${data_disk_list[@]};
do
  if [[ $i == ${DISK_NAME}[a-z] ]]; then
  parent_data_disk_array+=("$i") 
  sudo parted /dev/${i} --script mklabel gpt mkpart xfspart xfs 0% 100%
  sudo partprobe /dev/${i}
  echo ${i}
  fi
done

echo ${parent_data_disk_array[@]}  # 결과 sdc sdd ...

# for문이 돌때마다 배열에 0 번째 1번째 ... 자리에 data_disk_list 를 돌린다
# 돌린 후 나온 디스크 배열들을 mkfs xfs 파일시스템으로 형식 지정
for i in ${data_disk_list[@]};
do
  if [[ $i == ${DISK_NAME}[a-z][0-9] ]]; then
  child_data_disk_array+=("$i") 

    sudo mkfs.xfs /dev/${i}

  fi
done

echo ${child_data_disk_array[@]}  # 결과 sdc1 sdd1 ...

# 적어놓은 디렉토리 마운트 
for i in ${DIRECTORY_MOUNT[@]};
do
sudo mkdir ${i}
done

# /etc/fstab 에 영구적 마운트
UUID_array=() # UUID 배열 생성
exist_UUID=() # fstab용 존재 유무 배열 생성
FSTAB_EXIST=() 
for i in ${child_data_disk_array[@]};
do
  UUID=$(sudo blkid |grep -i /dev/${i}| awk '{print $2}')
  EXIST_BEFORE=$(sudo blkid |grep -i /dev/${i}| awk '{print $2}'|cut -f 2 -d '"')
  UUID_array+=($UUID)
  exist_UUID+=($EXIST_BEFORE)
  
done

for i in ${exist_UUID[@]};
do

  FSTAB_BEFORE=$(cat /etc/fstab|grep ${i} |awk '{print $1}')
  FSTAB_EXIST+=($FSTAB_BEFORE)
done
  
  echo " 현재 신규 마운트할 UUID는 다음과 같습니다. ${FSTAB_EXIST[@]}"

# 만약 /fstab에 해당 UUID가 존재한다면 실행하지 않는다.

for i in "${!UUID_array[@]}"; do
  if [[ ${UUID_array[$i]} == ${FSTAB_EXIST[$i]} ]]; then
  echo "/etc/fstab에 해당 ${UUID_array[$i]} 가 존재 합니다."
  else 
  sudo echo "${UUID_array[$i]}    ${DIRECTORY_MOUNT[$i]}  xfs defaults    0 0" >> /etc/fstab
  fi
done
sudo mount -a
