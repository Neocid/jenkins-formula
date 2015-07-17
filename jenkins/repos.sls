{% from "jenkins/map.jinja" import jenkins with context %}

jenkins:
  {% if grains['os_family'] in ['RedHat', 'Debian'] %}
  pkgrepo.managed:
    - humanname: {{ jenkins.lookup.humanname }}
    {% if grains['os_family'] == 'RedHat' %}
    - baseurl: http://pkg.jenkins-ci.org/redhat
    - gpgkey: http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
    {% elif grains['os_family'] == 'Debian' %}
    - name: {{ jenkins.lookup.name }}
    - key_url: {{ jenkins.lookup.key_url }}
    {% endif %}
    - require_in:
      - pkg: jenkins
  {% endif %}
  pkg.latest:
    - refresh: True
  service.running:
    - enable: True
    - watch:
      - pkg: jenkins