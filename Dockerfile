# 베이스 이미지 설정
FROM openjdk:17-slim as build

# 작업 디렉토리 설정
WORKDIR /workspace/app

# 필요한 패키지 설치 및 Chrome 설치
RUN apt-get update && apt-get install -y wget gnupg2 software-properties-common && \
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' && \
    apt-get update && \
    apt-get install -y google-chrome-stable=122.0.6261.112-1

# ChromeDriver 설치
RUN wget -N http://chromedriver.storage.googleapis.com/122.0.6261.111/chromedriver_linux64.zip -P /tmp && \
    unzip /tmp/chromedriver_linux64.zip -d /tmp && \
    mv -f /tmp/chromedriver /usr/local/bin/chromedriver && \
    chmod 0755 /usr/local/bin/chromedriver && \
    rm /tmp/chromedriver_linux64.zip

# 애플리케이션 소스 코드 복사 및 빌드
COPY . .
RUN ./gradlew build -x test

# 최종 이미지 설정
FROM openjdk:17-slim

# 환경 변수 설정
ENV CHROME_BIN=/usr/bin/google-chrome \
    CHROME_DRIVER=/usr/local/bin/chromedriver

# 빌드 스테이지에서 생성된 jar 파일을 복사
COPY --from=build /workspace/app/build/libs/*.jar app.jar

# 애플리케이션 실행
ENTRYPOINT ["java", "-jar", "/app.jar"]
