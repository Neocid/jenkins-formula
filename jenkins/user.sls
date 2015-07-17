{% from "jenkins/map.jinja" import jenkins with context %}

jenkins_group:
  group.present:
    - name: {{ jenkins.config.group }}
    - system: True

jenkins_user:
  file.directory:
    - name: {{ jenkins.config.home }}
    - user: {{ jenkins.config.user }}
    - group: {{ jenkins.config.group }}
    - mode: 0755
    - require:
      - user: jenkins_user
      - group: jenkins_group
  user.present:
    - name: {{ jenkins.config.user }}
    - groups:
      - {{ jenkins.config.group }}
    - system: True
    - home: {{ jenkins.config.home }}
    - shell: /bin/bash
    - require:
      - group: jenkins_group