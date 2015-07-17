jenkins_install:
    pkg.installed:
      - name: jenkins_pkg
      - sources:
        - jenkins: salt://jenkins/files/jenkins_1.620_all.deb
      - source_hash: md5=f781da3961dd15af963b9a12855c1c41
      - require:
        - pkg: java-jre7