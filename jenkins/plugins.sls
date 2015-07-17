{% from "jenkins/map.jinja" import jenkins with context %}
{%  set plugins = salt['pillar.get']('jenkins-plugins', {}) %}


# Based on this URL, the jenkins-cli.jar will be backward compatible
# https://wiki.jenkins-ci.org/pages/viewpage.action?pageId=55541777
jenkins-cli:
  file.managed:
    - name: {{ jenkins.config.home }}/jenkins-cli.jar
    - source: salt://jenkins/files/jenkins-cli.jar

jenkins-contact-update-server:
  cmd.run:
    - name: curl -L http://updates.jenkins-ci.org/update-center.json | sed '1d;$d' > {{ jenkins.config.home }}/updates/default.json
    - unless: test -d {{ jenkins_home }}/updates/default.json
    - require:
      - pkg: jenkins

{% for plugin in jenkins-plugins %}
{{ plugin }}:
  cmd.run:
    - name: java -jar jenkins-cli.jar -s "http://127.0.0.1:{{ port }}" install-plugin "{{ plugin }}"
    - unless: java -jar jenkins-cli.jar -s "http://127.0.0.1:{{ port }}" list-plugins | grep "{{ plugin }}"
    - cwd: /var/cache/jenkins/war/WEB-INF/
    - user: jenkins
    - require:
      - service: jenkins
      - cmd: jenkins-contact-update-server
    - watch_in:
      - cmd: jenkins-safe-restart

{% endfor %}