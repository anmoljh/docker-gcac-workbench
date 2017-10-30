# Galaxy - GCAC
#
# VERSION 1.0

From bgruening/galaxy-stable:17.05

MAINTAINER Anmol J. Hemrom <anmol.jh@gmail.com>

WORKDIR /galaxy-central

RUN apt-get update && apt-get install -y ed libreadline-dev texlive-base texlive-extra-utils \
    texlive-latex-base texlive-latex-extra texlive-latex-recommended texlive-luatex \
    texlive-generic-extra texlive-lang-cjk texlive-plain-extra  build-essential texlive-full \
    fort77 gfortran gnustep-devel node-zlib libpng-dev libpnglite-dev coinor-libcgl-dev \
    coinor-libsymphony-dev cdbs coinor-libcgl-dev libopenmpi-dev tcllib libghc-digest-dev \
    node-buffer-crc32 zlib-bin zlibc lua-zlib-dev node-zlib liblz-dev libghc-zlib-dev \
    zlib1g-dev zlib1g-dbg libnlopt-dev && rm -rf /var/lib/apt/lists/*

ADD ./gcac-workbench/tool_list_gcac.yaml $GALAXY_ROOT/tool_list_gcac.yaml 
ADD ./gcac-workbench/tool_conf_gcac.xml $GALAXY_ROOT/tool_conf_gcac.xml	

ENV GALAXY_CONFIG_BRAND="GCAC" \
    GALAXY_CONFIG_TOOL_CONFIG_FILE=$GALAXY_ROOT/tool_conf_gcac.xml,config/shed_tool_conf.xml 

RUN add-tool-shed --url 'http://testtoolshed.g2.bx.psu.edu/' --name 'Test ToolShed'
RUN install-tools $GALAXY_ROOT/tool_list_gcac.yaml


ADD ./gcac-workbench/gcac-workflow.ga $GALAXY_HOME/workflows/
RUN startup_lite && sleep 30 && \
    workflow-install --workflow_path $GALAXY_HOME/workflows/ -g http://localhost:8080 -u $GALAXY_DEFAULT_ADMIN_USER -p $GALAXY_DEFAULT_ADMIN_PASSWORD	

VOLUME ["/export/", "/data/", "/var/lib/docker"]

EXPOSE 80 21 8800

CMD ["/usr/bin/startup"]
