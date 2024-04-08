# 📖 포팅 매뉴얼
## 📌 목차
### 🍀 환경 변수
[Frontend](#frontend) <br>
[Backend](#backend) <br>

### 🛠️ 설치 및 실행
[1. Docker](#1-docker) <br>
[2. Docker Compose](#2-docker-compose) <br>
[3. Certbot](#3-certbot) <br>
[4. Nginx](#4-nginx) <br>
[5. MariaDB](#5-mariadb) <br>
[6. MongoDB](#6-mongodb) <br>
[7. Jenkins](#7-jenkins) <br>
[8. Distributed File System](#8-distributed-file-system) <br>

### ✈ 외부 서비스


## 🍀 환경 변수
### [Frontend]
 아래 변수들을 .env 파일에 넣으세요.
 ```
 AES_KEY='[백엔드와 공유하는 aesKey]';
 KAKAO_NATIVE_APP_KEY='[카카오 네이티브 앱 키]';
 API_URL='[API베이스Url]';
 ```
### [Backend]
 아래 파일 속 암호화된 값들을 [**application-key.yml**](./application-key.yml)의 jasypt 키로 복호화하여 사용합니다.
- [backend/src/main/resources/application.yml](./../backend/src/main/resources/application.yml)
- [backend/src/main/resources/application-data.yml](./../backend/src/main/resources/application-data.yml)
- [backend/src/main/resources/application-db.yml](./../backend/src/main/resources/application-db.yml)

## 🛠️ 설치 및 실행
EC2 인스턴스 [백엔드 서버] - Nginx, Spring App <br>
EC2 인스턴스 [분산 서버] - Hadoop, Cassandra, Airflow <br>
EC2 인스턴스 [CI/CD] - Jenkins <br>
EC2 인스턴스 [DB] - MariaDB, MongoDB

### [1. Docker]
1.1 HTTPS 관련 패키지 설치
```
sudo apt install apt-transport-https ca-certificates curl software-properties-common
```
1.2 도커 공식 GPG 키 추가
```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```
1.3 도커 저장소 추가
```
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
```
1.4 업데이트
```
sudo apt-get update
```
1.5 도커 설치
```
sudo apt-get install docker-ce docker-ce-cli containerd.io
```
1.6 도커 그룹에 사용자 추가
```
sudo usermod -aG docker ${USER}
```

### [2. Docker Compose]
2.1 환경 변수 설정
```
DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
```
2.2 디렉토리 생성
```
mkdir -p $DOCKER_CONFIG/cli-plugins
```
2.3 도커 컴포즈 설치
```
curl -SL https://github.com/docker/compose/releases/download/v2.24.7/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose
```
2.4 실행 권한 부여
```
chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose
```
### [3. Certbot]
3.1 Certbot 설치
```
sudo snap install --classic certbot
```
3.2 Certbot command 준비
```
sudo ln -s /snap/bin/certbot /usr/bin/certbot
```
3.3 인증서 발급 후 아래 디렉토리에 복사
```
sudo certbot certonly --nginx
```
### [4. Nginx]
| 디렉토리 구조
```
/home
/ubuntu
/server
├── docker-compose.yml
└── nginx
    └── nginx.conf
    └── certs
        ├── fullchain.pem
        └── privkey.pem
```
4.1 docker-compose.yml 작성
```
services:
  nginx:
    image: nginx:latest
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf
      - ./nginx/certs:/etc/nginx/certs
```
4.2 nginx.conf 작성
```
events {
    worker_connections  1024;
}

http {
    server {
        listen 80;
        server_name j10d110.p.ssafy.io;

        location / {
            return 301 https://$host$request_uri;
        }
  }
    server {
        listen 443 ssl;
        server_name j10d110.p.ssafy.io;

        ssl_certificate /etc/nginx/certs/fullchain.pem;
        ssl_certificate_key /etc/nginx/certs/privkey.pem;

        location / {
            root /usr/share/nginx/html;
            index index.html index.html;
        }

        location /api {
            proxy_pass http://spring-app:8080;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
}
```
### [5. MariaDB]
5.1 볼륨 설정
```
docker volume create mariadb_data
```
5.2 MariaDB 컨테이너 생성
```
docker run -d \
--name mariadb-server \
-e MYSQL_ROOT_PASSWORD="Pickachu123!" \
-e MYSQL_DATABASE="pickachu" \
-e MYSQL_USER="zzang" \
-e MYSQL_PASSWORD="Pickachu123!" \
-p 3306:3306 \
-v mariadb_data:/var/lib/mysql \
mariadb:latest \
--lower_case_table_names=1
```
### [6. MongoDB]
6.1 볼륨 설정
```
docker volume create mongodb_data
```
6.2 MongoDB 컨테이너 생성
```
docker run  -d \
--name mongodb-server \
-p 27017:27017 \
-v mongodb_data:/data/db \
mongo:latest
```
### [7. Jenkins]
7.1 볼륨 생성 후 Jenkins 컨테이너 생성
```
docker run -d -p 8080:8080 -p 50000:50000 \
-v /var/run/docker.sock:/var/run/docker.sock \
-v jenkins_home:/var/jenkins_home \
--name jenkins \
jenkins/jenkins:lt
```
7.2 컨테이너 내부 권한 설정
```
docker exec -it jenkins bash
chown -R jenkins:jenkins /var/jenkins_home
chmod -R 755 /var/jenkins_home
```
7.3 Jenkins 웹 인터페이스를 통해 플러그인 설치 및 관리자 계정 생성 <br>
7.4 Credentials 설정
### [8. Distributed File System]
[링크 참고](./distributed_file_system_setting.md)
### [flutter]
괄호친 명령어를 터미널에 입력하세요
1. 레포지토리 클론 ( git clone {피카추-레포지토리-url} )
2. 터미널 실행 및 Project 디렉토리 이동 ( cd frontend )
3. pubspec.yaml 파일에서 의존성 적용 ( flutter pub get )
4. 안드로이드 스튜디오 애뮬레이터 설치 및 적용
5. (flutter pub run flutter_launcher_icons -f flutter_launcher_icons.yaml)
6. (dart run flutter_native_splash:create)
7. (dart run flutter_native_splash:create --path=[프로젝트경로]/flutter_native_splash.yaml)
8.  run 'main.dart' 버튼 클릭 ( flutter run )

