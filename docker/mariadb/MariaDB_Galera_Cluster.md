## MariaDB Galera Cluster

MariaDB Galera Cluster is a virtually synchronous multi-master cluster for MariaDB.
  1. Linux Only
  1. InnoDB Storage Engine Only
  1. 가상 동기화 복제 방식
    a. [Virtually synchronous replication](https://mariadb.com/kb/en/about-galera-replication/)
  1. Active-active multi-master 방식
  1. 모든 Node 에서 읽고 쓰기
  1. 자동 참여 Node 관리
    a. 실패 Node 를 Cluster 에서 제거
  1. 자동 Cluster 참여
  1. 병렬 복제 방식
  1. 직접 클라이언트 연결
  1. Slave 로 인한 지연 없음
  1. 손실 작업 없음
    a. Cluster 모든 Node 데이터 일관성 보장
  1. 읽기 확장
    a. 모든 Node 에서 읽기 가능
  1. 클라이언트 대기 최소화




### Critical Read

#### wsrep_sync_wait

이 변수를 설정하면 값으로 지정된 유형의 조작을 실행하기 전에 인과 관계 확인이 수행되어 명령문이 완전히 동기화 된 노드에서 실행됩니다

확인이 수행되는 동안 서버에서 확인이 시작된 시점까지 클러스터에서 이루어진 모든 업데이트를 따라 잡을 수 있도록 새 쿼리가 노드에서 차단됩니다

도달하면 원래 쿼리가 노드에서 실행됩니다

이로 인해 대기 시간이 길어질 수 있습니다

  * 값의 범위
    * 0 ~ 15 (> = MariaDB 10.2.9 , MariaDB 10.1.27 , MariaDB Galera 10.0.32 , MariaDB Galera 5.5.57 )
    * 0 ~ 7 (<= MariaDB 10.2.8 , MariaDB 10.1.26 , MariaDB Galera 10.0.31 , MariaDB Galera 5.5.56 )

  * 사용예)
    * SET SESSION wsrep_sync_wait=1; SELECT ...; SET SESSION wsrep_sync_wait=0;




swarm mode 에서는 내부 사용 IP 에 대해서 고정 IP 를 사용할 수가 없다

#### 참조
  * https://stackoverflow.com/questions/45180892/static-ip-address-doesnt-work-in-docker-compose-v3
  * [Static/Reserved IP addresses for swarm services #24170](https://github.com/moby/moby/issues/24170)
  * https://docs.docker.com/compose/compose-file/compose-file-v3/#ipv4_address-ipv6_address

### 참조
  1. [What is MariaDB Galera Cluster?](https://mariadb.com/kb/en/what-is-mariadb-galera-cluster/)
  1. [About Galera Replication](https://mariadb.com/kb/en/about-galera-replication/)
  1. [Overview of Galera Cluster](https://galeracluster.com/library/documentation/overview.html)
  1. [MariaDB Galera in Docker: Persistent Storage and Automating the Bootstrapping Process](https://medium.com/@_matthanley/mariadb-galera-in-docker-persistent-storage-and-automating-the-bootstrapping-process-b5600db35e21)
    a. https://github.com/matthanley/docker-galera
  1. https://github.com/colinmollenhour/mariadb-galera-swarm
  1. [Official MariaDB Dockfile](https://github.com/MariaDB/mariadb-docker/blob/5d57b119775458cd37994a0f313ea3a29603efbb/10.5/Dockerfile)
  1. [MariaDB Galera Cluster-설치/셋팅](https://cirius.tistory.com/1766)
  1. https://gywn.net/2012/09/mariadb-galera-cluster/
  1. [wsrep_sync_wait](https://mariadb.com/kb/en/galera-cluster-system-variables/#wsrep_sync_wait)
