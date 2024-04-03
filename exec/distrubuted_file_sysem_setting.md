# 분산 환경 설정 총 정리

---

EC2 인스턴스를 여러 개 두면 편하지만

제한된 자원(EC2 한 개)으로 운영해야하므로 도커 컨테이너로 노드를 분리하기 위해

이러한 시도를 하게 되었음.

<aside>
💡 시작하기 전에, 아쉬웠던 점 몇 가지를 먼저 언급하자면

1) docker에서 root권한으로 모든 것을 실행한  것임.

만약 또 구축할 일이 생긴다면 컨테이너마다 사용자를 하나 만들어서 그 곳에서 수행할 것 같다.
2) 컨테이너를 일일이 구성하는 것이 번거롭고, 나중에 Airflow도 함께 쓰려면 미리 docker compose를 설치해서 사용하면 좋았을 듯 하다.
3) 추가로 관리 도구로 Kubernetes 사용도 한번 고려해보고 싶다.

4) 24.04.02 리소스 과다로 서버가 죽었다.
   도커 볼륨을 기본값으로 작게 설정한 것도 문제이고, zeppelin 메모리도 작게 설정한 것이 문제인 듯하다. 
그리고 기본적으로 Cassandra, Zeppelin이 메모리를 많이 잡아먹는데, 테스트 하느라 Cassandra IO 작업이 너무 많았던 것도 문제였다.

그리고 Airflow가 (특히 trigger) CPU 사용량을 100%이상 차지했다.

</aside>

> **base node 설치 & 필수 설치 프로그램**
> 

1) 도커 네트워크 생성

```bash
# zeppelin 내부 통신을 위한 사용자 정의 네트워크 생성
sudo docker network create d110-network

# base image를 만들기 위한 도커 파일 생성
nano Dockerfile
```

2) Dockerfile 작성

```bash
FROM ubuntu:20.04

# install essential libraries
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y dist-upgrade

RUN apt-get install -y wget unzip ssh openssh-* net-tools

# install java 1.8 for Hadoop
RUN apt-get install -y openjdk-8-jdk
RUN find / -name java-8-openjdk-amd64 2>/dev/null

# set environment variable
ENV PATH="${PATH}:/usr/lib/jvm/java-8-openjdk-amd64/bin"
ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"

SHELL ["/bin/bash", "-c"]
RUN echo 'export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64' >> ~/.bashrc
RUN source ~/.bashrc

# install python 3.8
RUN apt-get install -y python3-pip

# ssh setup
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
RUN cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
RUN chmod 0600 ~/.ssh/authorized_keys

# install hadoop
RUN wget https://dlcdn.apache.org/hadoop/common/hadoop-3.2.4/hadoop-3.2.4.tar.gz
RUN tar -zxvf hadoop-3.2.4.tar.gz
RUN mv hadoop-3.2.4 hadoop

# set environment variable
ENV PATH="${PATH}:/root/cluster/hadoop/bin:/root/cluster/hadoop/sbin"
ENV HADOOP_HOME="/root/cluster/hadoop"

RUN echo 'export HADOOP_HOME=/root/cluster/hadoop' >> ~/.bashrc;
RUN echo 'export HADOOP_COMMON_HOME=$HADOOP_HOME' >> ~/.bashrc;
RUN echo 'export HADOOP_HDFS_HOME=$HADOOP_HOME' >> ~/.bashrc;
RUN echo 'export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop' >> ~/.bashrc;
RUN echo 'export YARN_CONF_DIR=$HADOOP_HOME/etc/hadoop' >> ~/.bashrc;
RUN echo 'export HADOOP_YARN_HOME=$HADOOP_HOME' >> ~/.bashrc;
RUN echo 'export HADOOP_MAPRED_HOME=$HADOOP_HOME' >> ~/.bashrc;

RUN source ~/.bashrc
```

 - 원래 하둡시스템에서도 보안을 위해 사용자를 하나 만드는 것이 맞음

 - 그런데 도커컨테이너를 실행할 시 root 권한으로 먼저 들어가짐.
 - 따라서 편의상 root 권한으로 운영, 이때 홈 디렉토리가 /home/ubuntu가 아닌 /root 임을 주의 + sudo 키워드 없음 주의

 - hadoop 등등 여러 파일들의 경우 버전이 있는지 확인하고 다운받을 것.

3) 도커 파일 대로 이미지 빌드

```bash
# 현재 폴더에서 'Dockerfile'을 찾아 이 파일대로 init-image라는 이미지를 빌드
sudo docker build -t init-image .

# 이미지 확인
sudo docker images
```

4) 도커 컨테이너 생성 - 마스터 네임노드

**주의!! 반드시 컨테이너를 처음 생성할 때 포트를 모두 미리 지정해주어야한다.**

```bash
sudo docker run -i -d --network d110-network --hostname master-namenode --name master-namenode -p 18080:18080 -p 8088:8088 -p 18888:18888 -p 50070:50070 -p 2181:2181 init-image
```

- -i 옵션을 꼭 붙여줘야 컨테이너 생성 시 바로 Exited되지 않고 실행됨.
- -d : 백그라운드 실행. 안붙이면 바로 접속되는 것으로 알고있음
- --hostname : 호스트네임도 붙이면 편한데 생성할 때 아니면 수정할 수 없으므로 반드시 이 때 지정해주기
- --network : 위에서 지정해준 네트워크로 연결하기

여기서 환경 변수 추가로 마저 설정해 준 다음, 이걸 이미지화 해서 나머지 노드 생성 예정

5) 접속 후 이미지 기반 다른 노드들 생성

```bash
# 접속
sudo docker exec -it <container-id> /bin/bash
```

- 환경 변수 추가 설정

```bash
# 환경변수 등록
nano /etc/environment
> PATH += :/usr/lib/jvm/java-8-openjdk-amd64/bin
> JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"

# Framework 환경변수 사전 설정
> PATH += ":/root/cluster/hadoop/bin" 
> PATH += ":/root/cluster/hadoop/sbin"

> HADOOP_HOME="/root/cluster/hadoop"
> SPARK_HOME="/root/cluster/spark"
> ZOOKEEPER_HOME="/root/cluster/zookeeper"

source /etc/environment
```

 - 여기서도 /home/ubuntu 대신 /root를 사용했음 주의

- 작업용 폴더 생성

```bash
mkdir ~/cluster

# 이후 위에서 설치했던 하둡 폴더 옮기기
```

- 도커 이미지화

```bash
exit

sudo docker commit -m "make base node" <컨테이너 이름> <새 이미지 이름>
```

- 다른 노드들(secondary namenode, datanode, datanode2) 컨테이너 생성

```bash
sudo docker run -i -d --network d110-network --hostname master-secondary-namenode --name master-secondary-namenode -p 2182:2181 basenode-image
sudo docker run -i -d --network d110-network --hostname worker-datanode --name worker-datanode -p 2183:2181 basenode-image
sudo docker run -i -d --network d110-network --hostname worker-datanode2 --name worker-datanode2 basenode-image
```

 - master-secondary-namenode : 2182:2181 포트포워딩

 - worker-datanode: 2183:2181 포트포워딩

(zookeeper는 최소 3개의 journal node가 필요해서 위의 마스터네임노드 포함 3개만 포트 오픈.)

 

6) ssh 접속을 위한 환경 설정

```bash
# master node로 접속
sudo docker exec -it <container-id> /bin/bash
```

** ssh 접속 테스트

ssh: connect to host localhost port 22: Cannot assign requested address

```bash
service ssh start

ssh localhost
```

- /etc/hosts 수정

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/9eb5318d-fb4e-4cd4-ab31-d8a51ba80e99/899c11c1-fb51-4b5c-a67f-fa9ae5829348/Untitled.png)

위처럼 private ip주소 확인

사용자 정의 네트워크의 경우 172.18 부터 시작함. (위 사진은 벌써 네번째 네트워크…)

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/9eb5318d-fb4e-4cd4-ab31-d8a51ba80e99/34a97a52-91b3-4c25-80ed-38bc9ef2cb06/Untitled.png)

- 다른 컨테이너에도 적용

```bash
cat /etc/hosts | ssh master-secondary-namenode "sh -c 'cat >/etc/hosts'"
cat /etc/hosts | ssh worker-datanode "sh -c 'cat >/etc/hosts'"
cat /etc/hosts | ssh worker-datanode2 "sh -c 'cat >/etc/hosts'"
```

### **💢 Trouble Shooting - ssh**

<aside>
💡 **Host key verification failed**

</aside>

이런걸 여러번시도했더니 자꾸 host key verification failed 문제 발생

처음 한두번은 잘됨..

목표: ssh 비밀번호 입력없이 ‘ssh 호스트네임’ 만으로도 자유로이 접속하기

1) ssh-keygen -t rsa 로 key를 생성

2) id_rsa, id_rsa.pub, authorized_keys를 가진 채로 이미지 생성

3) 이 이미지 기반으로 나머지 컨테이너들 생성

4) ssh 접속

⇒ Host key verification failed 문제 발생

⇒ ssh-keygen -R 호스트네임 을 활용하여 초기화

⇒ known_hosts에서 찾을 수 없다는 문제 발생(호스트네임 or ip가 존재하지 않는다는 문제 발생)

⇒ 여기서 많이 고민했는데 그냥,

**known_hosts에서 해당 지문을 삭제하고 다시 ssh 접속을 시도하면 된다.**

7) 필수 프로그램 설치

```bash
# ZOOKEEPER 3.8.4
cd ~/cluster;
wget https://dlcdn.apache.org/zookeeper/zookeeper-3.8.4/apache-zookeeper-3.8.4-bin.tar.gz;
tar -xzvf apache-zookeeper-3.8.4-bin.tar.gz;
mv apache-zookeeper-3.8.4-bin ~/cluster/zookeeper;

# SPARK 3.2.4
cd ~/cluster;
wget https://archive.apache.org/dist/spark/spark-3.2.4/spark-3.2.4-bin-hadoop3.2.tgz;
tar -xvf spark-3.2.4-bin-hadoop3.2.tgz;
mv spark-3.2.4-bin-hadoop3.2 ~/cluster/spark;

# ZEPPELIN 0.10.1
cd ~/cluster;
wget https://dlcdn.apache.org/zeppelin/zeppelin-0.10.1/zeppelin-0.10.1-bin-all.tgz;
```

 - 사이트에 들어가서 버전을 체크하고 다운 받을 것. (아니면 존재하지 않는다고 404 오류남)

> **하둡 환경 설정**
> 

1) hdfs-site.xml 수정

```xml
    <!-- Put site-specific property overrides in this file. -->
<configuration>
    <!-- hdfs basic configuration-->
    <property>
        <name>dfs.replication</name>
        <value>3</value>
    </property>
    <property>
        <name>dfs.namenode.name.dir</name>
        <value>/root/cluster/data/dfs/namenode</value>
    </property>
    <property>
        <name>dfs.datanode.data.dir</name>
        <value>/root/cluster/data/dfs/datanode</value>
    </property>

    <!-- configuration for HA and Federation -->
    <property>
        <name>dfs.nameservices</name>
        <value>dfs-cluster</value>
    </property>
    <property>
        <name>dfs.ha.namenodes.dfs-cluster</name>
        <value>namenode1,namenode2</value>
    </property>
    <property>
        <name>dfs.namenode.rpc-address.dfs-cluster.namenode1</name>
        <value>master-namenode:8020</value>
    </property>
    <property>
        <name>dfs.namenode.rpc-address.dfs-cluster.namenode2</name>
        <value>master-secondary-namenode:8020</value>
    </property>
    <property>
        <name>dfs.namenode.http-address.dfs-cluster.namenode1</name>
        <value>master-namenode:50070</value>
    </property>
    <property>
        <name>dfs.namenode.http-address.dfs-cluster.namenode2</name>
        <value>master-secondary-namenode:50070</value>
    </property>

    <!-- journalnodes group-->
    <property>
        <name>dfs.namenode.shared.edits.dir</name>
        <value>qjournal://master-namenode:8485;master-secondary-namenode:8485;worker-datanode:8485/dfs>
    </property>
    <property>
        <name>dfs.journalnode.edits.dir</name>
        <value>/root/cluster/data/dfs/journalnode</value>
    </property>

    <!-- configuration of fail-over-->
    <property>
        <name>dfs.client.failover.proxy.provider.dfs-cluster</name>
        <value>org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider</value>
    </property>
    <property>
        <name>dfs.ha.fencing.methods</name>
        <value>shell(/bin/true)</value>
    </property>
    <property>
        <name>dfs.ha.automatic-failover.enabled</name>
        <value>true</value>
    </property>
</configuration>

```

 - namenode service id로 dfs-cluster라고 지어줌. 

 - 그리고 서비스의 네임노드들을 앞서 만들어준 2개의 네임노드로 지정해줌.

2) core-site.xml 수정

```xml
<configuration>
    <!-- Set HDFS default file system, Heartbeat from datanodes -->
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://dfs-cluster</value>
    </property>

    <!-- write zookeeper management server address; port 2181 -->
   <property>
        <name>ha.zookeeper.quorum</name>
        <value>master-namenode:2181,master-secondary-namenode:2181,worker-datanode:2181</value>
    </property>
</configuration>
```

3) yarn-site.xml 수정

```xml
<configuration>
    <property>
        <name>yarn.resourcemanager.hostname</name>
        <value>master-namenode</value>
    </property>

    <!-- Assistant service for MapReduce Shuffle -->
    <property>
        <name>yarn.nodemanager.aux-services</name>
        <value>mapreduce_shuffle</value>
    </property>
    <property>
        <name>yarn.nodemanager.aux-services.mapreduce_shuffle.class</name>
        <value>org.apache.hadoop.mapred.ShuffleHandler</value>
    </property>

    <!-- Restrict virtual memory use if memory use is beyond limit: False -->
    <property>
        <name>yarn.nodemanager.vmem-check-enabled</name>
        <value>false</value>
     </property>
</configuration>
```

4) mapred-site.xml 수정

```xml
<configuration>
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
    </property>
    <property>
        <name>yarn.app.mapreduce.am.env</name>
        <value>HADOOP_MAPRED_HOME=${HADOOP_HOME}</value>
    </property>
    <property>
        <name>mapreduce.map.env</name>
        <value>HADOOP_MAPRED_HOME=${HADOOP_HOME}</value>
    </property>
    <property>
        <name>mapreduce.reduce.env</name>
        <value>HADOOP_MAPRED_HOME=${HADOOP_HOME}</value>
    </property>
</configuration>
```

5) hadoop_env.sh에 추가

```bash
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export HADOOP_HOME=/root/cluster/hadoop
```

6) ~/cluster/hadoop/etc/hadoop 아래 masters 파일과 workers파일 생성 후 내용 입력

- masters (생성)

```bash
nano masters
```

```bash
master-namenode
master-secondary-namenode
```

 - 호스트네임 작성해주면 됨

- workers (수정)

```bash
nano workers
```

```bash
worker-datanode
worker-datanode2
```

 - 기존에 있었던 localhost는 삭제

> **zookeeper 설정**
> 

1) ~/cluster/zookeeper/conf로 이동 후 zoo_sample.cfg를 zoo.cfg로 변경

```bash
cd ~/cluster/zookeeper/conf
mv zoo_sample.cfg zoo.cfg
```

2) .bashrc 파일에 ZOOKEEPER_HOME 환경변수 추가

```bash
echo 'export ZOOKEEPER_HOME=/root/cluster/zookeeper' >> ~/.bashrc
source ~/.bashrc
```

3) zoo.cfg 편집

- `2888` : Leader가 Follower에게 열어놓은 동기화용 포트
- `3888` : Leader가 죽으면 Leader 선출을 위한 포트
- `clientPort` : Hadoop Client `core-site.xml`
- `dataDir` : Zookeeper Stage, Transaction 로그, etc 관리

```bash
# The number of milliseconds of each tick
tickTime=2000
# The number of ticks that the initial
# synchronization phase can take
initLimit=10
# The number of ticks that can pass between
# sending a request and getting an acknowledgement
syncLimit=5
# the directory where the snapshot is stored.
# do not use /tmp for storage, /tmp here is just
# example sakes.
dataDir=/root/cluster/zookeeper/data
dataLogDir=/root/cluster/zookeeper/logs
# the port at which the clients will connect
clientPort=2181
# the maximum number of client connections.
# increase this if you need to handle more clients
maxSessionTimeout=180000
maxClientCnxns=0

server.1=master-namenode:2888:3888
server.2=master-secondary-namenode:2888:3888
server.3=worker-datanode:2888:3888

#
# Be sure to read the maintenance section of the
# administrator guide before turning on autopurge.
#
# https://zookeeper.apache.org/doc/current/zookeeperAdmin.html#sc_maintenance
#
# The number of snapshots to retain in dataDir
#autopurge.snapRetainCount=3
# Purge task interval in hours
# Set to "0" to disable auto purge feature
#autopurge.purgeInterval=1

## Metrics Providers
#
# https://prometheus.io Metrics Exporter
#metricsProvider.className=org.apache.zookeeper.metrics.prometheus.PrometheusMetricsProvider
#metricsProvider.httpHost=0.0.0.0
#metricsProvider.httpPort=7000
#metricsProvider.exportJvmInfo=true
```

 - 서버 세 대를 주키퍼 앙상블로 설정.

 - server뒤에 들어가는 숫자 → myid 

⇒ 이걸로 서버 분간

4) myid 설정

- zookeeper 폴더 아래 data 폴더 생성

```bash
mkdir ~/cluster/zookeeper/data
```

- master namenode의 myid를 1로 설정

```bash
echo 1 > ~/cluster/zookeeper/data/myid
```

 - 후에 secondary namenode, worker datanode에도 각각 2, 3 설정해줄 예정임.

> **설정한 내용들을 다른 노드들에게도 복사**
> 

1) hadoop 복사

```bash
scp -r ~/cluster/hadoop/etc root@master-secondary-namenode:~/cluster/hadoop/;
scp -r ~/cluster/hadoop/etc root@worker-datanode:~/cluster/hadoop;
scp -r ~/cluster/hadoop/etc root@worker-datanode2:~/cluster/hadoop;
```

 - 다른 노드들에 하둡이 설치되어 있으므로 etc 아래만 넣어주기

2) zookeeper 복사

```bash
scp -r ~/cluster/zookeeper root@master-secondary-namenode:~/cluster
scp -r ~/cluster/zookeeper root@worker-datanode:~/cluster
```

 - zookeeper노드에 해당되는 master secondary name node, data node 두 개에만 복사

3) zookeeper 노드들에게 myid 부여 (아까 못한 2, 3 설정)

```bash
ssh master-secondary-namenode 'echo 2 > ~/cluster/zookeeper/data/myid'
ssh worker-datanode 'echo 3 > ~/cluster/zookeeper/data/myid'
```

4) .bashrc설정도 복사

```bash
scp -r ~/.bashrc root@master-secondary-namenode:~/
scp -r ~/.bashrc root@worker-datanode:~/
scp -r ~/.bashrc root@worker-datanode2:~/
```

- 변경 내용 적용해주기

```bash
ssh master-secondary-namenode 'source ~/.bashrc'
ssh worker-datanode 'source ~/.bashrc'
ssh worker-datanode2 'source ~/.bashrc'
```

> **Zookeeper 데몬 실행하기**
> 

1) zookeeper 데몬 실행하기

```bash
# START
ssh master-namenode 'cluster/zookeeper/bin/zkServer.sh start';
ssh master-secondary-namenode 'cluster/zookeeper/bin/zkServer.sh start';
ssh worker-datanode 'cluster/zookeeper/bin/zkServer.sh start';

# STATUS
ssh master-namenode 'cluster/zookeeper/bin/zkServer.sh status';
ssh master-secondary-namenode 'cluster/zookeeper/bin/zkServer.sh status';
ssh worker-datanode 'cluster/zookeeper/bin/zkServer.sh status';

# STOP
ssh master-namenode 'cluster/zookeeper/bin/zkServer.sh stop';
ssh master-secondary-namenode 'cluster/zookeeper/bin/zkServer.sh stop';
ssh worker-datanode 'cluster/zookeeper/bin/zkServer.sh stop';
```

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/9eb5318d-fb4e-4cd4-ab31-d8a51ba80e99/11d88c81-e2e8-4e44-930c-ac26939d26e7/Untitled.png)

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/9eb5318d-fb4e-4cd4-ab31-d8a51ba80e99/e010b8e6-5728-4abe-b204-8be1697317c4/Untitled.png)

2) journalnode 켜기

```bash
ssh master-namenode '/root/cluster/hadoop/bin/hdfs --daemon start journalnode'
ssh master-secondary-namenode '/root/cluster/hadoop/bin/hdfs --daemon start journalnode'
ssh worker-datanode '/root/cluster/hadoop/bin/hdfs --daemon start journalnode'
```

** jps로 확인

`QuorumPeerMain` : Zookeeper

`JournalNode` : journal node group

혹시나 잘 안될땐 로그를 읽어보자

```bash
cat hadoop-root-journalnode-master-namenode.log
```

core-site에서 이상한 문자가 들어갔는지 UTF-8 파싱에 실패해서 안켜짐. 정상 동작 확인

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/9eb5318d-fb4e-4cd4-ab31-d8a51ba80e99/1e3df61a-aa8d-4091-93c8-2c1ba1cd69dc/Untitled.png)

3) zookeeper 초기화

- zkfc 세팅 전에 해줘야 할 작업.

```bash
hdfs zkfc -formatZK
```

4) zookeeper cli 접속

```bash
~/cluster/zookeeper/bin/zkCli.sh

> ls /hadoop-ha
> quit
```

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/9eb5318d-fb4e-4cd4-ab31-d8a51ba80e99/ddf68ff8-08bd-4ba4-9ac1-a701a55abeae/Untitled.png)

내가 앞서 지정한 네임서비스 id가 나오면 정상동작

> **Hadoop 데몬 실행하기**
> 

1) 네임노드 포맷

```bash
hdfs namenode -format
```

2) 네임노드 시작

```bash
hdfs --daemon start namenode
```

** jps로 확인

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/9eb5318d-fb4e-4cd4-ab31-d8a51ba80e99/31c8e358-1270-45cc-b90e-b5386e8d24e1/Untitled.png)

3) hdfs 컨트롤러 키기 (zookeeper failover controller)

```bash
hdfs --daemon start zkfc
```

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/9eb5318d-fb4e-4cd4-ab31-d8a51ba80e99/49a1d631-e52e-4598-9125-05989b7fd1ba/Untitled.png)

4) master-secondary-namenode를  standby node로 지정

- 스탠바이할 네임노드로 접속

```bash
ssh master-secondary-namenode
```

```bash
hdfs namenode -bootstrapStandby
```

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/9eb5318d-fb4e-4cd4-ab31-d8a51ba80e99/0bfb1b5c-f999-4932-9eef-cd9c6254324e/Untitled.png)

5) namenode 시작

```bash
hdfs --daemon start namenode
```

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/9eb5318d-fb4e-4cd4-ab31-d8a51ba80e99/3d9412ee-35e9-423f-a0cd-ad0a94e0dc53/Untitled.png)

6) zkfc 키기

```bash
hdfs --daemon start zkfc
```

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/9eb5318d-fb4e-4cd4-ab31-d8a51ba80e99/8b56278b-cd72-4954-bcf9-dd9ae87e2a97/Untitled.png)

** 확인

```bash
hdfs haadmin -getServiceState namenode1
hdfs haadmin -getServiceState namenode2

hdfs haadmin -getAllServiceState
```

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/9eb5318d-fb4e-4cd4-ab31-d8a51ba80e99/e3744485-8f80-4726-ae35-e6f3939f4092/Untitled.png)

7) 모든 노드의 분산 파일 시스템 키기

```bash
start-dfs.sh
```

### **💢 Trouble Shooting - daemon 실행**

<aside>
💡 **Attempting to operate on hdfs namenode as root
but there is no HDFS_NAMENODE_USER defined. Aborting operation.**

</aside>

하둡은 기본적으로 보안을 위해서 사용자를 만들어서 실행하기를 권장함.

그래서 원래 사용자 계정에서 할 때는 따로 지정해주지 않아도 됨.

하지만 편의 상 루트 계정에서 진행하므로 추가로 설정해주어야함.

하둡 홈 디렉토리에서 [hadoop-env.sh](http://hadoop-env.sh) 파일을 열고 아래 행을 추가

```bash
export HDFS_NAMENODE_USER=root
export HDFS_DATANODE_USER=root
export HDFS_JOURNALNODE_USER=root
export HDFS_SECONDARYNAMENODE_USER=root
export YARN_RESOURCEMANAGER_USER=root
export YARN_NODEMANAGER_USER=root
export HDFS_ZKFC_USER=root
```

** jps 확인

```bash
ssh master-namenode jps; echo '========='; ssh master-secondary-namenode jps; echo '========='; ssh worker-datanode jps; echo '========='; ssh worker-datanode2 jps;
```

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/9eb5318d-fb4e-4cd4-ab31-d8a51ba80e99/04badf7d-bbe3-427c-99e1-416286f5cd21/Untitled.png)

8) yarn 실행

```bash
start-yarn.sh
```

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/9eb5318d-fb4e-4cd4-ab31-d8a51ba80e99/7df7bddb-6bb1-4eb5-8c2a-a56a7040863c/Untitled.png)

<aside>
💡 **정리**

네임노드 → `ResourceManager` (Active만), `Namenode`

데이터노드 → `NodeManager`, `DataNode`
Journal group → `JournalNode`

Active, Standby Node (Failover) → `DFSZFailoverController` 

Zookeeper 노드들 → `QuorumPeerMain`

</aside>

> **Hadoop 데모 테스트**
> 

1) job history server 키기(선택)

```bash
mapred --daemon start historyserver
```

2) health check(선택)

```bash
hdfs dfsadmin -report
```

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/9eb5318d-fb4e-4cd4-ab31-d8a51ba80e99/359ded2e-213b-4a7b-a612-2dddd8ea4e0e/Untitled.png)

 - 잘 살아있는 우리 데이터노드들

3) 폴더 생성 및 파일 적재

```bash
hdfs dfs -mkdir /example
```

```bash
hdfs dfs -put ~/cluster/hadoop/README.txt /example/input.txt
```

4) 맵리듀스 예제 코드 실행

```bash
yarn jar ~/cluster/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.2.4.jar wordcount /example/input.txt /example/output
```

5) 확인

- Reducer가 한 개로 지정되어 있어서 00000 하나 뿐임

```bash
hdfs dfs -ls /example/output
```

```bash
hdfs dfs -cat /example/output/part-r-00000
```

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/9eb5318d-fb4e-4cd4-ab31-d8a51ba80e99/8dc40c2c-6227-4eee-b4ca-c3025d920a92/Untitled.png)

> **Web UI 테스트**
> 

1) public IP 확인

```bash
curl ifconfig.me
```

2) namenode에 접속해보기

```bash
브라우저에 3.35.216.47:50070
```

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/9eb5318d-fb4e-4cd4-ab31-d8a51ba80e99/ef9ce3ed-bd34-4c12-b7d9-b4c25448c066/Untitled.png)

### **💢** Trouble Shooting

어… 근데 약간의 문제…

도커 컨테이너들이 호스트의 네트워크 인터페이스를 공유하는 바람에 저거 하나로밖에 접속 못함..

상관은 없지만 다른 노드들 확인이 불가…

뭔가 포트를 zookeepr처럼 다르게 지정했어야 됐을..지도?

50070:50070, 50071:50070 이런식으로

근데 사실 일단 마스터노드만 보이면 다라서, 그냥 안할 예정 ㅋ

더 이상의 갈아엎기란.. 불가.. ㅋ

3) yarn에 접속해보기

```bash
브라우저에 3.35.216.47:8088
```

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/9eb5318d-fb4e-4cd4-ab31-d8a51ba80e99/913f9852-3183-474b-baa7-58847209ca58/Untitled.png)

> **Spark 세팅**
> 

1) spark-env.sh를 수정하러 이동

```bash
cd ~/cluster/spark/conf
```

2) spark-env 파일 이름 수정

```bash
mv spark-env.sh.template spark-env.sh
```

3) [spark-env.sh](http://spark-env.sh)에 추가

```bash
export SPARK_HOME=/root/cluster/spark
export SPARK_CONF_DIR=/root/cluster/spark/conf
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export HADOOP_HOME=/root/cluster/hadoop
export HADOOP_CONF_DIR=/root/cluster/hadoop/etc/hadoop
export SPARK_MASTER_WEBUI_PORT=18080
```

4) spark-defaults.conf 파일 이름 수정

```bash
mv spark-deaults.conf.template spark-defaults.conf
```

5) spark-defaults.conf에 추가

```bash
spark.master    yarn
spark.eventLog.enabled  true
spark.eventLog.dir      /root/cluster/spark/logs
```

6) workers 파일 이름 수정

```bash
mv workers.template workers
```

7) workers에 [localhost](http://localhost) 지우고 데이터노드들 등록

```bash
worker-datanode
worker-datanode2
```

8) .bashrc에 추가

```bash
export PYTHONPATH=/usr/bin/python3
export PYSPARK_PYTHON=/usr/bin/python3

# 적용
source ~/.bashrc
```

- 다른 노드들에도 복사

```bash
scp -r ~/.bashrc root@master-secondary-namenode:~/
scp -r ~/.bashrc root@worker-datanode:~/
scp -r ~/.bashrc root@worker-datanode2:~/

# 적용
ssh master-secondary-namenode 'source ~/.bashrc'
ssh worker-datanode 'source ~/.bashrc'
ssh worker-datanode2 'source ~/.bashrc'
```

9) 스파크 설정 다른 곳에도 복사

- 모든 마스터와 워커들에게 보내기

```bash
scp -r ~/cluster/spark root@master-secondary-namenode:~/cluster
scp -r ~/cluster/spark root@worker-datanode:~/cluster
scp -r ~/cluster/spark root@worker-datanode2:~/cluster
```

> **Spark 데몬 실행**
> 

1) cluster/spark/sbin 아래 있는 [start-all.sh](http://start-all.sh) 실행

```bash
cd ~/cluster/spark/sbin
./start-all.sh
```

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/9eb5318d-fb4e-4cd4-ab31-d8a51ba80e99/ffac1e32-6f9b-498f-8801-e604fa076183/Untitled.png)

 - Master, Worker가 추가로 표시된 것을 볼 수 있다.

 - 만약 안 켜지면 [stop-all.sh](http://stop-all.sh) 하고 다시 키면 됨

** 브라우저에서도 확인

```bash
브라우저에 http://3.35.216.47:18080/ 입력
```

2) spark submit 실행

```bash
cd ~/cluster/spark/bin
spark-submit --class org.apache.spark.examples.SparkPi --master yarn --deploy-mode cluster --driver-memory 512m --executor-memory 512m --executor-cores 1 $SPARK_HOME/examples/jars/spark-examples_*.jar 5
```

 - master : yarn-cluster-manager

 (로컬모드 → local, 스파크에서 제공하는 standalone-cluster → spark-masterhost report)

관련 레퍼런스: https://spark.apache.org/docs/latest/submitting-applications.html

 - deploy mode : cluster mode

 - driver 개수: 512개

 - 코어 개수: 1개

 - 작업 : spark-examples에서 주는 파일

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/9eb5318d-fb4e-4cd4-ab31-d8a51ba80e99/cdf3bcfd-c74f-4d1d-a1ce-4158ad6590af/Untitled.png)

yarn이 수행했기 때문에 yarn(8088)으로 들어가서 보면

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/9eb5318d-fb4e-4cd4-ab31-d8a51ba80e99/f09a8094-dc65-4f5a-acff-52b7fa18441a/Untitled.png)

> **Automatic Failover on HDFS Cluster**
> 

kill -9 를 이용해서 Active node의 Namenode를 죽이면, Standby노드가 Active로 전환됨.

그리고 mapred job을 실행시키면 새로운 Active node에서 실행됨.

- 전환된 모습

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/9eb5318d-fb4e-4cd4-ab31-d8a51ba80e99/b729c067-66de-41a6-88dd-24be4ee5ad2a/Untitled.png)

- secondary에서 정상 실행

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/9eb5318d-fb4e-4cd4-ab31-d8a51ba80e99/d76a30d0-0560-4722-8a8d-d89838d3b33a/Untitled.png)

> **Zeppelin 설정 세팅과 데몬 실행**
> 

1) (이미 깔고 압축을 해제했다면) .bashrc에 환경변수 추가

```bash
export ZEPPELIN_HOME=~/cluster/zeppelin

# 적용
source ~/.bashrc
```

2) zeppelin-site.xml 파일 이름 변경

```bash
cd ~/cluster/zeppelin/conf
mv zeppelin-site.xml.template zeppelin-site.xml
```

3) zeppelin-site.xml에 추가

```xml
<property>
  <name>zeppelin.server.addr</name>
  <value>0.0.0.0</value>
  <description>Server binding address</description>
</property>

<property>
  <name>zeppelin.server.port</name>
  <value>18888</value>
  <description>Server port.</description>
</property>
```

 - 18888 OR Up to Your Preference

4) [zeppelin-env.sh](http://zeppelin-env.sh) 파일 이름 변경

```xml
mv zeppelin-env.sh.template zeppelin-env.sh
```

5) [zeppelin-env.sh](http://zeppelin-env.sh) 파일에 추가

- 프레임워크 설정

```bash
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

export HADOOP_HOME=/root/cluster/hadoop
export YARN_CONF_DIR=$HADOOP_HOME/etc/hadoop
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop

export SPARK_HOME=/root/cluster/spark
export SPARK_MASTER=yarn
export ZEPPELIN_PORT=18888

export PYTHONPATH=/usr/bin/python3
export PYSPARK_PYTHON=/usr/bin/python3
export PYSPARK_DRIVER_PYTHON=/usr/bin/python3
```

 - zeppelin은 다른 노드에 복사할 필요 없음.

6) zeppelin 데몬 시작

```bash
cd ~/cluster/zeppelin/bin
./zeppelin-daemon.sh start
```

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/9eb5318d-fb4e-4cd4-ab31-d8a51ba80e99/d7e3ba55-11e3-4216-bb2e-fb6d4ef6300c/Untitled.png)

7) 브라우저로 제플린 서버 접속

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/9eb5318d-fb4e-4cd4-ab31-d8a51ba80e99/3f9f6346-2be4-44e1-8b45-c5e48261f81b/Untitled.png)

8) 추가 세팅

- 인터프리터 접속

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/9eb5318d-fb4e-4cd4-ab31-d8a51ba80e99/f494f864-5f10-44e4-9814-6ed01bb3964a/Untitled.png)

- Spark 검색 후 Edit 클릭

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/9eb5318d-fb4e-4cd4-ab31-d8a51ba80e99/757b160d-ea92-4052-90f8-223dc1efd79b/Untitled.png)

- 추가로 변경한 부분

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/9eb5318d-fb4e-4cd4-ab31-d8a51ba80e99/46e2b7bb-93ae-4c09-8737-62f1f87079a8/Untitled.png)

 - 환경에 맞춰 자유롭게 바꾸면 됨.

** 카산드라 커넥터 추가

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/9eb5318d-fb4e-4cd4-ab31-d8a51ba80e99/a6e8c770-339c-4a6a-bd08-6ed247c63987/Untitled.png)

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/9eb5318d-fb4e-4cd4-ab31-d8a51ba80e99/bb008ff3-ac32-4ff7-a5bd-9dd0cde58cb8/Untitled.png)

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/9eb5318d-fb4e-4cd4-ab31-d8a51ba80e99/0e6da90a-d14f-40de-8654-a589cd07821f/Untitled.png)

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/9eb5318d-fb4e-4cd4-ab31-d8a51ba80e99/f9390503-d758-4064-a15f-595c7339a80a/Untitled.png)

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/9eb5318d-fb4e-4cd4-ab31-d8a51ba80e99/add1b271-1e45-44bc-8f8f-f15b7fc5fae8/Untitled.png)

- Save > Ok
    
    ⇒ 알아서 restart 해줌
    
- Home > Notebook > Create new note

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/9eb5318d-fb4e-4cd4-ab31-d8a51ba80e99/9c8432e2-36f2-4be1-badb-40765f995eb1/Untitled.png)

### **💢** Trouble Shooting

수많은 재시작으로 인해… 갑자기 **Interpreter is not preccessing. Connect timeout 오류가 뜬다면! 스파크와 제플린 상에 연결이 끊어진 것이다.**

- 에러코드
    
    ```python
    org.apache.zeppelin.interpreter.InterpreterException: java.io.IOException: Interpreter process is not running
    Interpreter download command: /usr/lib/jvm/java-8-openjdk-amd64/bin/java -Dfile.encoding=UTF-8 -Dlog4j.configuration=log4j_yarn_cluster.properties -Dzeppelin.log.file=/root/cluster/zeppelin/logs/zeppelin-interpreter-spark-shared_process--master-namenode.log -cp :/root/cluster/zeppelin/interpreter/spark/*:::/root/cluster/zeppelin/interpreter/zeppelin-interpreter-shaded-0.10.1.jar:/root/cluster/zeppelin/interpreter/spark/spark-interpreter-0.10.1.jar:/root/cluster/hadoop/etc/hadoop org.apache.zeppelin.interpreter.remote.RemoteInterpreterDownloader 172.21.0.2 45091 spark /root/cluster/zeppelin/local-repo/spark
    log4j:WARN No appenders could be found for logger (org.apache.zeppelin.interpreter.remote.RemoteInterpreterDownloader).
    log4j:WARN Please initialize the log4j system properly.
    log4j:WARN See http://logging.apache.org/log4j/1.2/faq.html#noconfig for more info.
    [INFO] Interpreter launch command: /root/cluster/spark/bin/spark-submit --class org.apache.zeppelin.interpreter.remote.RemoteInterpreterServer --driver-java-options  -Dfile.encoding=UTF-8 -Dlog4j.configuration=log4j_yarn_cluster.properties -Dzeppelin.log.file=/root/cluster/zeppelin/logs/zeppelin-interpreter-spark-shared_process--master-namenode.log --conf spark.yarn.dist.archives=/root/cluster/spark/R/lib/sparkr.zip#sparkr --conf spark.yarn.isPython=true --conf spark.executor.instances=3 --conf spark.app.name=spark-shared_process --conf spark.webui.yarn.useProxy=false --conf spark.driver.cores=1 --conf spark.yarn.maxAppAttempts=1 --conf spark.executor.memory=1g --conf spark.master=yarn --conf spark.files=/root/cluster/zeppelin/conf/log4j_yarn_cluster.properties --conf spark.driver.memory=1g --conf spark.jars=/root/cluster/zeppelin/local-repo/spark/spotbugs-annotations-3.1.12.jar,/root/cluster/zeppelin/local-repo/spark/slf4j-api-1.7.26.jar,/root/cluster/zeppelin/local-repo/spark/config-1.3.4.jar,/root/cluster/zeppelin/local-repo/spark/java-driver-core-shaded-4.7.2.jar,/root/cluster/zeppelin/local-repo/spark/java-driver-shaded-guava-25.1-jre-graal-sub-1.jar,/root/cluster/zeppelin/local-repo/spark/java-driver-mapper-runtime-4.7.2.jar,/root/cluster/zeppelin/local-repo/spark/spark-cassandra-connector-driver_2.12-3.0.0.jar,/root/cluster/zeppelin/local-repo/spark/scala-reflect-2.12.11.jar,/root/cluster/zeppelin/local-repo/spark/jsr305-3.0.2.jar,/root/cluster/zeppelin/local-repo/spark/paranamer-2.8.jar,/root/cluster/zeppelin/local-repo/spark/spark-cassandra-connector_2.12-3.0.0.jar,/root/cluster/zeppelin/local-repo/spark/jcip-annotations-1.0-1.jar,/root/cluster/zeppelin/local-repo/spark/native-protocol-1.4.10.jar,/root/cluster/zeppelin/local-repo/spark/metrics-core-4.0.5.jar,/root/cluster/zeppelin/local-repo/spark/javatuples-1.2.jar,/root/cluster/zeppelin/local-repo/spark/commons-lang3-3.9.jar,/root/cluster/zeppelin/local-repo/spark/scala-library-2.12.11.jar,/root/cluster/zeppelin/local-repo/spark/java-driver-query-builder-4.7.2.jar,/root/cluster/zeppelin/local-repo/spark/HdrHistogram-2.1.11.jar,/root/cluster/zeppelin/local-repo/spark/reactive-streams-1.0.2.jar,/root/cluster/zeppelin/interpreter/spark/scala-2.12/spark-scala-2.12-0.10.1.jar,/root/cluster/zeppelin/interpreter/zeppelin-interpreter-shaded-0.10.1.jar --conf spark.executor.cores=1 --conf spark.submit.deployMode=cluster --conf spark.yarn.submit.waitAppCompletion=false /root/cluster/zeppelin/interpreter/spark/spark-interpreter-0.10.1.jar 172.21.0.2 45091 spark-shared_process :
    2024-04-03 00:46:05,638 WARN util.NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
    2024-04-03 00:46:06,221 INFO client.DefaultNoHARMFailoverProxyProvider: Connecting to ResourceManager at master-namenode/172.21.0.2:8032
    2024-04-03 00:46:07,642 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 0 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:08,643 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 1 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:09,644 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 2 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:10,644 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 3 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:11,645 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 4 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:12,646 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 5 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:13,646 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 6 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:14,647 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 7 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:15,648 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 8 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:16,649 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 9 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:17,657 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 0 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:18,658 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 1 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:19,659 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 2 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:20,659 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 3 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:21,660 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 4 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:22,661 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 5 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:23,661 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 6 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:24,662 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 7 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:25,663 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 8 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:26,663 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 9 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:26,665 INFO retry.RetryInvocationHandler: java.net.ConnectException: Call From master-namenode/172.21.0.2 to master-namenode:8032 failed on connection exception: java.net.ConnectException: Connection refused; For more details see:  http://wiki.apache.org/hadoop/ConnectionRefused, while invoking ApplicationClientProtocolPBClientImpl.getClusterMetrics over null after 1 failover attempts. Trying to failover after sleeping for 26075ms.
    2024-04-03 00:46:53,741 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 0 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:54,741 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 1 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:55,742 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 2 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:56,743 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 3 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:57,744 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 4 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:58,744 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 5 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:59,745 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 6 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:47:00,746 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 7 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:47:01,746 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 8 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:47:02,747 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 9 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:47:02,748 INFO retry.RetryInvocationHandler: java.net.ConnectException: Call From master-namenode/172.21.0.2 to master-namenode:8032 failed on connection exception: java.net.ConnectException: Connection refused; For more details see:  http://wiki.apache.org/hadoop/ConnectionRefused, while invoking ApplicationClientProtocolPBClientImpl.getClusterMetrics over null after 2 failover attempts. Trying to failover after sleeping for 41946ms.
    
    	at org.apache.zeppelin.interpreter.remote.RemoteInterpreter.open(RemoteInterpreter.java:129)
    	at org.apache.zeppelin.interpreter.remote.RemoteInterpreter.getFormType(RemoteInterpreter.java:271)
    	at org.apache.zeppelin.notebook.Paragraph.jobRun(Paragraph.java:438)
    	at org.apache.zeppelin.notebook.Paragraph.jobRun(Paragraph.java:69)
    	at org.apache.zeppelin.scheduler.Job.run(Job.java:172)
    	at org.apache.zeppelin.scheduler.AbstractScheduler.runJob(AbstractScheduler.java:132)
    	at org.apache.zeppelin.scheduler.RemoteScheduler$JobRunner.run(RemoteScheduler.java:182)
    	at java.util.concurrent.Executors$RunnableAdapter.call(Executors.java:511)
    	at java.util.concurrent.FutureTask.run(FutureTask.java:266)
    	at java.util.concurrent.ScheduledThreadPoolExecutor$ScheduledFutureTask.access$201(ScheduledThreadPoolExecutor.java:180)
    	at java.util.concurrent.ScheduledThreadPoolExecutor$ScheduledFutureTask.run(ScheduledThreadPoolExecutor.java:293)
    	at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1149)
    	at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:624)
    	at java.lang.Thread.run(Thread.java:750)
    Caused by: java.io.IOException: Interpreter process is not running
    Interpreter download command: /usr/lib/jvm/java-8-openjdk-amd64/bin/java -Dfile.encoding=UTF-8 -Dlog4j.configuration=log4j_yarn_cluster.properties -Dzeppelin.log.file=/root/cluster/zeppelin/logs/zeppelin-interpreter-spark-shared_process--master-namenode.log -cp :/root/cluster/zeppelin/interpreter/spark/*:::/root/cluster/zeppelin/interpreter/zeppelin-interpreter-shaded-0.10.1.jar:/root/cluster/zeppelin/interpreter/spark/spark-interpreter-0.10.1.jar:/root/cluster/hadoop/etc/hadoop org.apache.zeppelin.interpreter.remote.RemoteInterpreterDownloader 172.21.0.2 45091 spark /root/cluster/zeppelin/local-repo/spark
    log4j:WARN No appenders could be found for logger (org.apache.zeppelin.interpreter.remote.RemoteInterpreterDownloader).
    log4j:WARN Please initialize the log4j system properly.
    log4j:WARN See http://logging.apache.org/log4j/1.2/faq.html#noconfig for more info.
    [INFO] Interpreter launch command: /root/cluster/spark/bin/spark-submit --class org.apache.zeppelin.interpreter.remote.RemoteInterpreterServer --driver-java-options  -Dfile.encoding=UTF-8 -Dlog4j.configuration=log4j_yarn_cluster.properties -Dzeppelin.log.file=/root/cluster/zeppelin/logs/zeppelin-interpreter-spark-shared_process--master-namenode.log --conf spark.yarn.dist.archives=/root/cluster/spark/R/lib/sparkr.zip#sparkr --conf spark.yarn.isPython=true --conf spark.executor.instances=3 --conf spark.app.name=spark-shared_process --conf spark.webui.yarn.useProxy=false --conf spark.driver.cores=1 --conf spark.yarn.maxAppAttempts=1 --conf spark.executor.memory=1g --conf spark.master=yarn --conf spark.files=/root/cluster/zeppelin/conf/log4j_yarn_cluster.properties --conf spark.driver.memory=1g --conf spark.jars=/root/cluster/zeppelin/local-repo/spark/spotbugs-annotations-3.1.12.jar,/root/cluster/zeppelin/local-repo/spark/slf4j-api-1.7.26.jar,/root/cluster/zeppelin/local-repo/spark/config-1.3.4.jar,/root/cluster/zeppelin/local-repo/spark/java-driver-core-shaded-4.7.2.jar,/root/cluster/zeppelin/local-repo/spark/java-driver-shaded-guava-25.1-jre-graal-sub-1.jar,/root/cluster/zeppelin/local-repo/spark/java-driver-mapper-runtime-4.7.2.jar,/root/cluster/zeppelin/local-repo/spark/spark-cassandra-connector-driver_2.12-3.0.0.jar,/root/cluster/zeppelin/local-repo/spark/scala-reflect-2.12.11.jar,/root/cluster/zeppelin/local-repo/spark/jsr305-3.0.2.jar,/root/cluster/zeppelin/local-repo/spark/paranamer-2.8.jar,/root/cluster/zeppelin/local-repo/spark/spark-cassandra-connector_2.12-3.0.0.jar,/root/cluster/zeppelin/local-repo/spark/jcip-annotations-1.0-1.jar,/root/cluster/zeppelin/local-repo/spark/native-protocol-1.4.10.jar,/root/cluster/zeppelin/local-repo/spark/metrics-core-4.0.5.jar,/root/cluster/zeppelin/local-repo/spark/javatuples-1.2.jar,/root/cluster/zeppelin/local-repo/spark/commons-lang3-3.9.jar,/root/cluster/zeppelin/local-repo/spark/scala-library-2.12.11.jar,/root/cluster/zeppelin/local-repo/spark/java-driver-query-builder-4.7.2.jar,/root/cluster/zeppelin/local-repo/spark/HdrHistogram-2.1.11.jar,/root/cluster/zeppelin/local-repo/spark/reactive-streams-1.0.2.jar,/root/cluster/zeppelin/interpreter/spark/scala-2.12/spark-scala-2.12-0.10.1.jar,/root/cluster/zeppelin/interpreter/zeppelin-interpreter-shaded-0.10.1.jar --conf spark.executor.cores=1 --conf spark.submit.deployMode=cluster --conf spark.yarn.submit.waitAppCompletion=false /root/cluster/zeppelin/interpreter/spark/spark-interpreter-0.10.1.jar 172.21.0.2 45091 spark-shared_process :
    2024-04-03 00:46:05,638 WARN util.NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
    2024-04-03 00:46:06,221 INFO client.DefaultNoHARMFailoverProxyProvider: Connecting to ResourceManager at master-namenode/172.21.0.2:8032
    2024-04-03 00:46:07,642 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 0 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:08,643 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 1 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:09,644 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 2 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:10,644 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 3 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:11,645 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 4 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:12,646 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 5 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:13,646 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 6 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:14,647 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 7 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:15,648 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 8 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:16,649 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 9 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:17,657 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 0 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:18,658 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 1 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:19,659 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 2 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:20,659 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 3 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:21,660 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 4 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:22,661 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 5 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:23,661 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 6 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:24,662 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 7 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:25,663 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 8 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:26,663 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 9 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:26,665 INFO retry.RetryInvocationHandler: java.net.ConnectException: Call From master-namenode/172.21.0.2 to master-namenode:8032 failed on connection exception: java.net.ConnectException: Connection refused; For more details see:  http://wiki.apache.org/hadoop/ConnectionRefused, while invoking ApplicationClientProtocolPBClientImpl.getClusterMetrics over null after 1 failover attempts. Trying to failover after sleeping for 26075ms.
    2024-04-03 00:46:53,741 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 0 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:54,741 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 1 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:55,742 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 2 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:56,743 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 3 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:57,744 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 4 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:58,744 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 5 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:46:59,745 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 6 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:47:00,746 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 7 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:47:01,746 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 8 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:47:02,747 INFO ipc.Client: Retrying connect to server: master-namenode/172.21.0.2:8032. Already tried 9 time(s); retry policy is RetryUpToMaximumCountWithFixedSleep(maxRetries=10, sleepTime=1000 MILLISECONDS)
    2024-04-03 00:47:02,748 INFO retry.RetryInvocationHandler: java.net.ConnectException: Call From master-namenode/172.21.0.2 to master-namenode:8032 failed on connection exception: java.net.ConnectException: Connection refused; For more details see:  http://wiki.apache.org/hadoop/ConnectionRefused, while invoking ApplicationClientProtocolPBClientImpl.getClusterMetrics over null after 2 failover attempts. Trying to failover after sleeping for 41946ms.
    
    	at org.apache.zeppelin.interpreter.remote.RemoteInterpreter.internal_create(RemoteInterpreter.java:157)
    	at org.apache.zeppelin.interpreter.remote.RemoteInterpreter.open(RemoteInterpreter.java:126)
    	... 13 more
    ```
    

1) Spark Interpreter를 재시작해보기 - 웹 상에서 가능

2) 안된다면, zeppelin에서 `zepeelin-daemon.sh restart`를 사용해서 제플린 재실행

3) 그래도 안된다면, 로그를 확인

⇒ 8032는 yarn-site.xml에서 따로 hostname만 지정하고 포트를 지정하지 않았을때 나오는 디폴트값임
이 디폴트 값도 잘 안되는 거라면, 그냥 resource manager 재실행

```python
2024-04-03 00:47:02,748 INFO retry.RetryInvocationHandler: java.net.ConnectException: Call From master-namenode/172.21.0.2 to master-namenode:8032 failed on connection exception: java.net.Connec>

        at org.apache.zeppelin.interpreter.remote.RemoteInterpreter.internal_create(RemoteInterpreter.java:157)
        at org.apache.zeppelin.interpreter.remote.RemoteInterpreter.open(RemoteInterpreter.java:126)
        ... 13 more

```

4) `[stop-yarn.sh](http://stop-yarn.sh)` and `start-yarn.sh`

혹은 나는 그냥 모두를 껐다 켰다. (`stop-all.sh` and `start-all.sh`)

> **CSV 파일 업로드**
> 

1) bash를 열어서 ec2로 복사

```bash
scp -i <private key> <csv data> ubuntu@<domain>:~
```

2) docker container로 복사

```bash
sudo docker cp card-data_201909.csv master-namenode:/root/cluster
```

3) hdfs로 복사

```bash
hdfs dfs -put card-data_201909.csv /example/card_201909.csv
```

> **Cassandra 연결**
> 

1) 카산드라용 새로운 컨테이너 생성

```bash
sudo docker run -i -d --network d110-network --hostname cassandra-db --name cassandra-db -p 9042:9042 ubuntu:20.04
```

 - spark, zeppelin과 같은 네트워크에 연결되어 있어야함.

 - 어차피 내부에서 도커 컨테이너들끼리 통신하는거라 포트 포워딩이 필요없지만 스프링 부트와의 연결을 위해 포트 지정

2) 카산드라 다운로드

```bash
wget https://archive.apache.org/dist/cassandra/4.1.4/apache-cassandra-4.1.4-bin.tar.gz
```

3) 압축해제

```bash
tar -xzvf <다운받은 cassandra 파일>
```

4) cassandra.yaml 파일 수정

```bash
seed_provider:
  # Addresses of hosts that are deemed contact points.
  # Cassandra nodes use this list of hosts to find each other and learn
  # the topology of the ring.  You must change this if you are running
  # multiple nodes!
  - class_name: org.apache.cassandra.locator.SimpleSeedProvider
    parameters:
      # seeds is actually a comma-delimited list of addresses.
      # Ex: "<ip1>,<ip2>,<ip3>"
      - seeds: "<컨테이너 주소>:7000"

listen_address=<컨테이너 주소>
rpc_address=<컨테이너 주소>
```

5) spark-default.conf 수정 (아래 내용을 추가)

```bash
spark.cassandra.connection.host 172.21.0.6
spark.cassandra.connection.port 9042
```

6) zeppelin에서 설정 변경

- spark interpreter에서 edit → connector 설정(datastax에서 나온 driver)
- cassandra interpreter

7) cassandra db 실행

```bash
cd ~/cassandra/bin
./cassandra -f
```

 - -f 옵션 : 포그라운드에서 실행

 - -R : root권한 실행을 권장하지 않는데, 그래도 해야겠다면 이 옵션을 추가

> **Cassandra에서 Keyspace(database) 및 테이블 생성**
> 

1) cqlsh 접속

```bash
./cqlsh
# 안된다면(자꾸 로컬로 접속한다면)
./cqlsh <ip주소> <port:9042>
```

2) key space 생성

```bash
CREATE KEYSPACE trend WITH replication = {'class': 'NetworkTopologyStrategy', 'datacenter1': 3} AND durable_writes = true;
```

- keyspace (옵션)작성 요령
    
    ### **1. 명확한 명명 규칙 사용**
    
    - Keyspace 이름은 목적이나 프로젝트 이름을 반영해야 하며, 애플리케이션에서 쉽게 식별할 수 있어야 합니다.
    - 일관된 명명 규칙을 사용하면 팀 내에서 혼란을 줄이고, 관리를 용이하게 합니다.
    
    ### **2. 복제 전략 선택**
    
    - **SimpleStrategy**: 개발 환경이나 단일 데이터 센터 환경에서 사용됩니다. 복제 팩터(Replication Factor, RF)만 지정합니다. 실제 운영 환경에서는 사용을 권장하지 않습니다.
    - **NetworkTopologyStrategy**: 운영 환경이나 여러 데이터 센터를 가진 경우에 사용됩니다. 데이터 센터별로 복제 팩터를 지정할 수 있으며, 더 세밀한 제어와 높은 가용성을 제공합니다.
    
    ### **3. 적절한 복제 팩터 설정**
    
    - 복제 팩터(RF)는 데이터의 가용성과 내구성에 영향을 미칩니다. RF를 너무 낮게 설정하면 데이터 손실의 위험이 증가하고, 너무 높게 설정하면 불필요한 저장 공간 사용과 성능 저하를 초래할 수 있습니다.
    - 일반적으로 RF는 3으로 설정하는 것이 좋습니다. 이는 데이터의 손실 없이 노드 장애를 처리할 수 있는 좋은 출발점입니다.
    
    ### **4. 키스페이스 생성 시 옵션 고려**
    
    - **DURABLE_WRITES**: 이 옵션은 데이터의 내구성을 제어합니다. **`true`**로 설정하면 모든 쓰기 작업이 커밋 로그에 기록됩니다. 특정한 경우를 제외하고는 대부분 **`true`**로 설정합니다.
    - **REPLICATION**: 여기에 복제 전략과 복제 팩터를 지정합니다. 전략과 팩터를 올바르게 선택하는 것이 중요합니다.
    
    ### **5. CQL 사용 예**
    
    아래는 **`NetworkTopologyStrategy`**를 사용하여 Keyspace를 생성하는 CQL 예시입니다.
    
    ```sql
    sqlCopy code
    CREATE KEYSPACE IF NOT EXISTS my_keyspace WITH replication = {'class': 'NetworkTopologyStrategy', 'datacenter1': 3} AND durable_writes = true;
    ```
    
    이 명령은 **`my_keyspace`**라는 이름의 Keyspace를 생성하고, **`datacenter1`**에서 복제 팩터 3을 사용하며, 내구적 쓰기를 활성화합니다.
    

3) key space 접속

```python
USE trend;
```

4) 테이블 생성

```sql
CREATE TABLE cardhistory(
	id uuid, userid int, date text, age text, ..., primary key(id));
```

 - PRIMARY KEY 지정 필수 

5) 테이블 조회

```sql
SELECT * FROM cardhistory;
```

 ** **where 옵션**을 사용하려면, 뒤에 `allow filtering` 을 붙여줘야한다.

카산드라에서는 필터링을 하게 되면 성능에 영향이 가기 때문에, 그럼에도 하겠다는 옵션을 붙여주는 것임.

> **Spring과 Cassandra 연결**
> 

1) application.yml에 cassandra 추가

```yaml
spring:
  cassandra:
    contact-points: <컨테이너 ip주소>
    keyspace-name: <위에서 설정한 keyspace (trend) >
    port: 9042
    local-datacenter: datacenter1
```

 - 위에 명시한 속성들은 모두 표시를 해줘야 Bean이 정상적으로 생성됨

 - Spring Boot 한정으로 yml 파일 덕분에 따로 CassandraConfig 파일을 생성할 필요는 없지만 추가 커스텀이 필요하다면 생성해야함(Cassandra Template)

⇒ **즉, yml에 다 표시가 안되어있으면 Config파일을 생성해서 속성을 지정해달라는 오류가 나오는 것.**

- 💡 **Tip: data center 확인하는 법**
    
    ```bash
    ./nodetool status 
    ```
    
    여기서 data center 확인 (난 안보였음ㅋ)
    
    혹은
    
    ```bash
    ./cqlsh <ip주소> 9042
    
    > cqlsh : SELECT data_center FROM system.local;
    ```
    
    (다른 peer node의 data center를 확인하고 싶다면, system.local 대신 system.peers
    

 -

2) Entity

```bash
package com.ssafy.pickachu.domain.statistics.entity;

import com.google.gson.annotations.SerializedName;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.cassandra.core.mapping.PrimaryKey;
import org.springframework.data.cassandra.core.mapping.Table;

import java.util.UUID;

@Data
@NoArgsConstructor
@Table("cardhistory")
public class CardHistoryEntity {

    @PrimaryKey
    private UUID id;
    private int userid;
    private String age;
    private String gender;
    @SerializedName("resUsedDate")
    private String date;
    @SerializedName("resUsedTime")
    private int time;
    @SerializedName("resUsedAmount")
    private int amount;
    @SerializedName("resMemberStoreType")
    private String category;
    private int cardId;
}

```

 - @Data는 lombok의 annotation으로 GETTER, SETTER, toString, hashCode 등을 만들어줌

3) Repository

```sql
package com.ssafy.pickachu.domain.statistics.repository;

import com.ssafy.pickachu.domain.statistics.entity.CardHistoryEntity;
import com.ssafy.pickachu.domain.statistics.entity.MyConsumptionEntity;
import org.springframework.data.cassandra.repository.CassandraRepository;
import org.springframework.data.cassandra.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CardHistoryEntityRepository extends CassandraRepository<CardHistoryEntity, Integer> {
    @Query("SELECT * FROM cardhistory WHERE userid = :userid ALLOW FILTERING")
    List<CardHistoryEntity> findMyCardHistoryById(@Param("userid") int userid);
}

```

4) Service

```sql
package com.ssafy.pickachu.domain.statistics.service;

import com.ssafy.pickachu.domain.statistics.response.CardHistoryRes;
import com.ssafy.pickachu.domain.user.entity.User;
import org.springframework.http.ResponseEntity;

public interface CardHistoryService {

    ResponseEntity<CardHistoryRes> saveCardHistoriesByAirflow(String apiKey);

    void saveCardHistories(String payListResult, User user, long id);

}
```

5) SerivceImpl

```sql
package com.ssafy.pickachu.domain.statistics.serviceImpl;

@Slf4j
@Service
@RequiredArgsConstructor
public class CardHistoryServiceImpl implements CardHistoryService {

    private final CardHistoryEntityRepository cardHistoryEntityRepository;

    @Override
    public void saveCardHistories(String payListResult, User user, long cardId) {
        PreparedStatement preparedStatement = cqlSession.prepare(
                "INSERT INTO cardhistory (id, userid, age, amount, cardid, category, date, gender, time) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"
        );
        BatchStatement batchStatement = BatchStatement.builder(DefaultBatchType.LOGGED).build();

        String userAgeGroup = commonUtil.calculateAge(user.getBirth());

        // 문자열 내용을 JSONArray 객체로 변환
        JSONArray jsonArray = new JSONArray(payListResult);

        // JSONArray 내용 처리 예시
        for (int i = 0; i < jsonArray.length(); i++) {
            JSONObject jsonObject = (JSONObject) jsonArray.get(i);

            CardHistoryEntity history = gson.fromJson(String.valueOf(jsonObject), CardHistoryEntity.class);
            history.setUserid((int) user.getId());
            history.setId(UUID.randomUUID());
            history.setGender(user.getGender());
            history.setAge(userAgeGroup);
            history.setCardId((int) cardId);
            // cardHistoryEntityRepository.save(history);
            // 배치 작업에 추가
            BoundStatement boundStatement = preparedStatement.bind(
                    history.getId(),
                    history.getUserid(),
                    history.getAge(),
                    history.getAmount(),
                    history.getCardId(),
                    history.getCategory(),
                    history.getDate(),
                    history.getGender(),
                    history.getTime()
            );
            batchStatement = batchStatement.add(boundStatement);
        }

        // 배치 작업으로 IO 줄이기
        cqlSession.execute(batchStatement);
    }

    @Override
    public ResponseEntity<CardHistoryRes> saveCardHistoriesByAirflow(String apiKey) {

        // API KEY 검증
        if(!apiKey.equals(this.apiKey)){
            throw new InvalidApiKeyException("API Key가 일치하지 않습니다.");
        }

        // 유저 전체에 대해서 데이터 요청
        List<User> userList = userRepository.findAll();
        CodefToken codefToken = codefRepository.findById(1)
                .orElseGet(() -> {
                    CodefToken token = CodefToken.builder()
                            .id(1)
                            .token(codefApi.GetToken())
                            .updateTime(LocalDateTime.now())
                            .build();
                    return  token;
                });

        // 어제 하루 내역 불러오기
        Calendar calendar = Calendar.getInstance();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
        calendar.add(Calendar.DATE, -1);
        String startDay = dateFormat.format(calendar.getTime());
        String endDay = startDay;

        // 유저별로
        for(User user : userList){
            try{
                // 카드별로
                List<PersonalCards> personalCards = personalCardsRepository.findAllByUserIdAndUseYN(user.getId(), user.getUseYN());
                for(PersonalCards card : personalCards){
                    RegisterCardsReq registerCardsReq = new RegisterCardsReq(
                        card.getCardCompany(), jasyptUtil.decrypt(card.getCardNo()), jasyptUtil.decrypt(card.getCardCompanyId()), jasyptUtil.decrypt(card.getCardCompanyPw())
                    );
                    String payListResult = codefApi.GetUseCardList(registerCardsReq, user, codefToken.getToken(),startDay,endDay);
                    saveCardHistories(payListResult, user, card.getId());
                }
            }catch (IOException e){
                throw new CardInfoIOException("카드 정보를 가져오는 데 문제가 발생했습니다.");
            }catch (Exception e){
                e.printStackTrace();
            }

        }

        CardHistoryRes cardHistoryRes = CardHistoryRes.createCardHistoryResponse(
                HttpStatus.OK.value(), "Success", "Success"
        );

        return ResponseEntity.ok(cardHistoryRes);
    }

}

```

### 💢 Trouble Shooting

Cassandra, Zeppelin이 모두 메모리를 많이 잡아먹는데,

테스트를 계속 하면서 Cassandra에 IO작업이 빈번해져 결국 서버가 죽고 말았다 …

카드 한 번만 등록해도, 카드 하나 당 100건의 카드 내역이 있다면 100번의 IO 작업이 발생.

심지어 도커 볼륨도 작아서 문제가 터진 것 같다.

그래서 코드를 다음과 같이 수정했다.

```java
    private final CardHistoryEntityRepository cardHistoryEntityRepository;

    @Override
    public void saveCardHistories(String payListResult, User user, long cardId) {
        PreparedStatement preparedStatement = cqlSession.prepare(
                "INSERT INTO cardhistory (id, userid, age, amount, cardid, category, date, gender, time) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"
        );
        BatchStatement batchStatement = BatchStatement.builder(DefaultBatchType.LOGGED).build();

        String userAgeGroup = commonUtil.calculateAge(user.getBirth());

        // 문자열 내용을 JSONArray 객체로 변환
        JSONArray jsonArray = new JSONArray(payListResult);

        // JSONArray 내용 처리 예시
        for (int i = 0; i < jsonArray.length(); i++) {
            JSONObject jsonObject = (JSONObject) jsonArray.get(i);

            CardHistoryEntity history = gson.fromJson(String.valueOf(jsonObject), CardHistoryEntity.class);
            history.setUserid((int) user.getId());
            history.setId(UUID.randomUUID());
            history.setGender(user.getGender());
            history.setAge(userAgeGroup);
            history.setCardId((int) cardId);
            // cardHistoryEntityRepository.save(history);
            // 배치 작업에 추가
            BoundStatement boundStatement = preparedStatement.bind(
                    history.getId(),
                    history.getUserid(),
                    history.getAge(),
                    history.getAmount(),
                    history.getCardId(),
                    history.getCategory(),
                    history.getDate(),
                    history.getGender(),
                    history.getTime()
            );
            batchStatement = batchStatement.add(boundStatement);
        }

        // 배치 작업으로 IO 줄이기
        cqlSession.execute(batchStatement);
```

Cassandra는 batch작업도 지원해주기 때문에, 배치를 사용해서 카드 하나당 한번의 IO 작업만 일어나도록 했다.

6) Controller

```sql
package com.ssafy.pickachu.domain.statistics.controller;

@RestController
@RequiredArgsConstructor
@CrossOrigin("*")
@RequestMapping("/statistics")
@Tag(name = "Statistics API", description = "빅데이터 분산 처리 통계 API")
public class StatisticsController {

    private final StatisticsService statisticsService;
    private final CardHistoryService cardHistoryService;

    @Operation(summary = "개인 소비 통계", description = "지난달 소비 내역과 업종 분석, 일자별 소비 금액 합계")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "(message : \"Success\", code : 200)",
                    content = @Content(schema = @Schema(implementation = MyConsumptionRes.class)))
    })
    @GetMapping("/consumption")
    public ResponseEntity<MyConsumptionRes> getConsumption(@AuthenticationPrincipal PrincipalDetails principalDetails){return statisticsService.getMyConsumption(principalDetails);}

}

```

> **파이프라인 자동화를 위한 Airflow 설치**
> 

[[데이터 엔지니어링 with Airflow] 4강. 도커를 사용하여 Airflow 설치하기](https://www.youtube.com/watch?v=_6FaI70td34)

1) docker compose 설치

```bash
sudo apt install docker-compose
```

 - 도커는 이미 깔려있으므로 생략하고 바로 도커 컴포즈를 설치한다.

### **💢** Trouble Shooting

docker pull 어쩌구를 할까 이걸 할까 고민했는데…. 그냥 시키는대로 하기로 했다.

근데 도커 컴포즈를 설치하는 과정에서 인지.. 아니면 yaml 파일따라 컨테이너를 생성하는 과정에서인지 뭔지 원인을 아직 찾지는 못했지만 뭔가 충돌이 있어서

기존에 돌아가던 나의 소중한 노드들과 카산드라가 모두 꺼졌다…ㅠ,ㅠ

다행히 꺼지기만 한거라 설정한 내용들은 다 그대로였는데

ssh service도 다시 켜줘야했고(다행히 키 지문 이런거는 그대로 사용가능 ㅎ)

모든 daemon을 다시 다 실행시켜줘야했다;; 정리하길 잘함

원인은 계속 찾는 중……

2) airflow를 설정하는 docker-compose.yaml 파일 다운받기

```bash
curl -LfO 'https://airflow.apache.org/docs/apache-airflow/2.5.1/docker-compose.yaml'
```

 - 참고로 저거 숫자 0이 아닌 알파벳 O임에 주의하자.
(숫자 0 했다가 자꾸 다운은 안되고 cat처럼 내용 출력만 됨)

3) 필요한 폴더 생성

```bash
mkdir -p ./dags ./logs ./plugins
```

4) env 설정(아마도 사용자를 설정하는듯 함)

```bash
 echo -e "AIRFLOW_UID=$(id -u)" > .env
```

 - 이거 하고 나면 .env파일이 생성되고, 내가 1000번 아이디를 가지고 있기 때문에 확인해보면 AIRFLOW_UID가 1000이라고 지정되어 있을 것이다.

4) airflow-init 실행

```bash
sudo docker compose up airflow-init
```

> **Airflow 실행**
> 

1) 도커 컴포즈를 사용하여 실행

```bash
sudo docker compose up
```

 - 함께 설치된 DB들도 깔려야 웹서버가 가동된다.

** ps로 확인

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/9eb5318d-fb4e-4cd4-ab31-d8a51ba80e99/339641c4-ee45-47c3-a4ce-941fa69dd23b/Untitled.png)

 - redis, postgl db도 설치되어있는 것을 확인할 수 있고, airflow 포트는 8080이다.

2) 브라우저로 접속

```bash
브라우저에 <내 외부 ip주소>:8080 으로 접속
```

 - 아이디, 비번 모두 airflow (docker-compose.yaml 보면 나와있음)

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/9eb5318d-fb4e-4cd4-ab31-d8a51ba80e99/3288f07a-bea6-4386-81ba-2403b020e955/Untitled.png)

3) 간단한 소개

<자주 사용하는 것들>

- Grid

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/9eb5318d-fb4e-4cd4-ab31-d8a51ba80e99/1236cbd8-e342-4a01-80b6-d315fd0191ec/Untitled.png)

위에 토글을 누르고 Auto-refresh도 하면 뭔가 뜸

- Graph

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/9eb5318d-fb4e-4cd4-ab31-d8a51ba80e99/0231a3a3-f870-4d83-9403-4fa127909857/Untitled.png)

task들을 확인할 수 있고 상태도 확인 가능

- Code

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/9eb5318d-fb4e-4cd4-ab31-d8a51ba80e99/1e797c7c-4a13-48d9-9312-4af5a8b6963c/Untitled.png)

UI상에서 코드도 작성할 수 있다.

4) DAG 파일 작성

- **Airflow 간단한 개념**
    
    [Airflow DAG 생성(Bash Operator)]
    
    ![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/9eb5318d-fb4e-4cd4-ab31-d8a51ba80e99/558f9287-9ef8-478e-8914-919afbb012f7/Untitled.png)
    
    - 오퍼레이터
        
        : 특정 행위를 할 수 있는 기능을 모아 놓은 클래스, 설계도
        
    - Task
        
        : 오퍼레이터에서 객체화(인스턴스화)되어 DAG에서 실행가능한 오브젝트
        
    - Bash Operator
        
        : 쉘 스크립트 명령을 수행하는 오퍼레이터
        
    
    [Task의 수행 주체]
    
    ![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/9eb5318d-fb4e-4cd4-ab31-d8a51ba80e99/f8449257-e309-4225-959e-1a13343dba68/Untitled.png)
    
    - 스케줄러
        
        : DAG Parsing 후 DB 정보 저장
        
        : DAG 시작 시간 결정
        
    - 워커
        
        : 실제 작업 수행
        
    
    (시작 지시할 때 큐를 사용)
    

- **example bash operator예시**

```python
from __future__ import annotations
import datetime
import pendulum # datetime을 좀 더 사용하기 쉽게함

from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.empty import EmptyOperator

def load_data_to_cassandra_by_api():
    api_url = 'http://j10d110.p.ssafy.io/api/load-data'
    response = requests.get(api_url)

    #요청이 성공적으로 처리 되었는지 확인
    if response.status_code == 200:
        print("Data successfully loaded to Cassandra.")
    else:
        raise Exception("Failed to load data to Cassandra.")

zeppelin_notebook_run_command_list = [
"""
curl -X POST http://j10d110a.p.ssafy.io:18888/#/notebook/2JSXPJ6AT
""",
"""
curl -X POST http://j10d110a.p.ssafy.io:18888/#/notebook/2JSACMPQ9
"""
]

with DAG(
        # dag의 이름(파일 이름과는 별개임, but 일치시키는 것이 좋음)
        dag_id="dags_d110",
        # cron schedule. 언제 실행될지 지정. "분 시 일 월 요일"
        schedule_interval="0 16 * * *",
        # dag이 언제부터 돌건지, catchup : start date와 현재 시간 사이의 누락된 부분을 모두 돌릴 것인지 말 것인지(true면 돌림. 단, 차례차례 도는 것이 아니라 한꺼번에 병렬로 실행됨)
        start_date=pendulum.datetime(2024, 3, 29, tz="Asia/Seoul"),
        catchup=False,
        # timeout 값 설정. 없어도 된다.
        # dagrun_timeout=datetime.timedelta(minutes=60),
        # 브라우저에서 dag 이름 밑에 보이는 태그 설정. 태그 별로 모아서 보기가 가능(따라서 Optional)
        tags=["spring api", "zeppelin notebook"],
        # 아래에 정의할 Task들에 공통으로 정의할 파라미터가 있다면 지정
        # params={"example_key": "example_value"},
) as dag:
    # [데이터 적재]
    insert_codef_data_to_cassandra_by_spring_api = PythonOperator( # task의 이름임. Operator로 만들어지는 task 객체의 이름
        task_id="insert_codef_data_to_cassandra_by_spring_api", # 브라우저에서 봤을 때 graph에서 나오는 task 이름. 마찬가지로 객체 이름과 별개지만 일치하도록
        python_callable=load_data_to_cassandra_by_api,
    )
    # [데이터 분석]
    for i in range(2):
        task = BashOperator(
            task_id="zeppelin_task_" + str(i),
            bash_command=zeppelin_notebook_run_command_list[i],
        )
        insert_codef_data_to_cassandra_by_spring_api >> task

```

 - >> : insert_codef_data_to_cassandra_by_spring_api가 성공적으로 수행되면 task가 수행되도록 의존성을 설정함. 그리고 저 insert는 한번만 수행된다.

5) docker-compose.yaml에 volumes부분을 수정(선택)

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/9eb5318d-fb4e-4cd4-ab31-d8a51ba80e99/a20d2889-6a68-4e6e-9858-cb77d631554b/Untitled.png)

 - `${AIRFLOW_PROJ_DIR:-.}`  : AIRFLOW_PROJ_DIR이 정의되어 있지 않으면 . 을 출력한다.

 - 즉, : 기준 앞 문장은 ./dags 인 것임.

 - : 을 중심으로 왼쪽은 ubuntu(ec2)의 볼륨, 오른쪽은 컨테이너의 볼륨

 - 만약 dags 파일을 airflow라는 폴더 아래에 dags 폴더에 저장해놨다면, (그리고 앞으로 계속 거기서 파일을 만들거라면, /dags 부분을 /airflow/dags로 수정하면 된다.)

<<수정>>

이유 : jwt토큰을 우회 하거나, 한번 받거나 해야 되는데 일단 우회 하고 나름의 보안 정책을 추가

```python
from __future__ import annotations
import datetime
import pendulum # datetime을 좀 더 사용하기 쉽게함
import os
import requests

from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.python import PythonOperator

def load_data_to_cassandra_by_api():
    api_url = 'http://j10d110.p.ssafy.io:8080/api/statistics/airflow'
    api_key = os.getenv('AIRFLOW_API_KEY', 'default_value')
    headers = {
        "AIRFLOW-API-KEY":api_key,
    }
    response = requests.get(api_url, headers=headers)

    #요청이 성공적으로 처리 되었는지 확인
    if response.status_code == 200:
        print("Data successfully loaded to Cassandra.")
    else:
        raise Exception(f"{response.status_code}: Failed to load data to Cassandra.")

zeppelin_notebook_run_command_list = [
"""
curl -X POST http://j10d110a.p.ssafy.io:18888/#/notebook/2JSXPJ6AT
""",
"""
curl -X POST http://j10d110a.p.ssafy.io:18888/#/notebook/2JSACMPQ9
"""
]

with DAG(
        # dag의 이름(파일 이름과는 별개임, but 일치시키는 것이 좋음)
        dag_id="dags_d110",
        # cron schedule. 언제 실행될지 지정. "분 시 일 월 요일"
        schedule_interval="0 7 * * *",
        # dag이 언제부터 돌건지, catchup : start date와 현재 시간 사이의 누락된 부분을 모두 돌릴 것인지 말 것인지(true면 돌림. 단, 차례차례 도는 것이 아니라 한꺼번에 병렬로 실행됨)
        start_date=pendulum.datetime(2024, 3, 29, tz="Asia/Seoul"),
        catchup=False,
        # timeout 값 설정. 없어도 된다.
        # dagrun_timeout=datetime.timedelta(minutes=60),
        # 브라우저에서 dag 이름 밑에 보이는 태그 설정. 태그 별로 모아서 보기가 가능(따라서 Optional)
        tags=["spring api", "zeppelin notebook"],
        # 아래에 정의할 Task들에 공통으로 정의할 파라미터가 있다면 지정
        # params={"example_key": "example_value"},
) as dag:
    # [데이터 적재]
    insert_codef_data_to_cassandra_by_spring_api = PythonOperator( # task의 이름임. Operator로 만들어지는 task 객체의 이름
        task_id="insert_codef_data_to_cassandra_by_spring_api", # 브라우저에서 봤을 때 graph에서 나오는 task 이름. 마찬가지로 객체 이름과 별개지만 일치하도록
        python_callable=load_data_to_cassandra_by_api,
    )
    # [데이터 분석]
    for i in range(2):
        task = BashOperator(
            task_id="zeppelin_task_" + str(i),
            bash_command=zeppelin_notebook_run_command_list[i],
        )
        insert_codef_data_to_cassandra_by_spring_api >> task

```

> **이후 작업할 내용**
> 

1) 매달 월 소비 데이터 적재 하기

Zeppelin에서 Cassandra 데이터셋을 hdfs로 옮기는 작업 수행하기 → 매달 1일 Airflow 실행되도록 하기

```python
# Cassandra에서 불러오기
df = spark.read \
    .format("org.apache.spark.sql.cassandra") \
    .options(table="TABLE_NAME", keyspace="KEYSPACE_NAME") \
    .load()

# 컬럼 조정 ... (user id 같은 부분은 제거)

# hdfs에 쓰기
df.write.format("parquet").save("hdfs:///path/to/hdfs/directory")

# 이후에 현재 hdfs에서 불러오는 데이터 작업 똑같이 수행하기...
# 월간, 연간도 전체 분석을 돌려봐도 좋을듯
```

2) 보안을 위해 hadoop에 kerberos 적용하기

