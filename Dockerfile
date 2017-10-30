FROM continuumio/anaconda3

# Set the ENTRYPOINT to use bash
# (this is also where you’d set SHELL,
# if your version of docker supports this)
ENTRYPOINT [ "/bin/bash", "-c" ]

EXPOSE 5000

# Use the environment.yml to create the conda environment.
ADD requirements.txt /tmp/requirements.txt
WORKDIR /tmp

RUN conda create --name paleopy --file requirements.txt && \
    /bin/bash -c 'source activate paleopy && pip install palettable'

ADD . /code
WORKDIR /code
#CMD [ "/bin/bash", "-c", "source activate paleopy && python setup.py install" ]

# We set ENTRYPOINT, so while we still use exec mode, we don’t
# explicitly call /bin/bash
#CMD [ "source activate paleopy && /bin/bash" ]
CMD [ "source activate paleopy && python setup.py install && python '/code/scripts/proxy_oper.py' --djsons '/code/test/web/jsons' --pjsons '/tmp' --opath '/tmp' --pfname script.json --name 'Avoca Glacier' --ptype 'Geomorphic' --longitude 171.405812 --latitude -43.043031 --dataset 'vcsn' --variable 'TMean' --season 'DJF' --qualitative 0 --value -0.53 --period '1972-2014' --climatology '1981-2010' --calc_anoms 1 --detrend 1 --aspect 131 --elevation 1979 --dating 'Absolute (calendar date BCE/CE)' --calendar '1450 CE - 1850 CE' --chronology '' --measurement 'Equilibrium line altitude (ELA)' --verbose 1" ]