# Container for running inference of
# https://github.com/RichardHarwood/Understanding-pore-space-at-the-root-soil-interface

#To build this file:
#sudo docker build . -t sydneyinformaticshub/soil

#To run this, mounting your current host directory in the container directory,
# at /project, and excute an example run:
#sudo docker run -it -v `pwd`:/project sydneyinformaticshub/soil /bin/bash -c "cd /project && python test.py"

#To push to docker hub:
#sudo docker push sydneyinformaticshub/soil

#To build a singularity container
#export SINGULARITY_CACHEDIR=`pwd`
#export SINGULARITY_TMPDIR=`pwd`
#singularity build soil.img docker://sydneyinformaticshub/soil

#To run the singularity image (noting singularity mounts the current folder by default)
#singularity run --bind /project:/project soil.img /bin/bash -c "cd "$PBS_O_WORKDIR" && python test.py"

# Pull base image.
FROM ubuntu:16.04
MAINTAINER Nathaniel Butterworth USYD SIH

RUN mkdir /scratch /project

RUN apt-get update -y && \
	apt-get install git curl build-essential libsm6 libxext6 libxrender-dev libgl1 libfreetype6-dev -y && \
	rm -rf /var/lib/apt/lists/*

WORKDIR /build

# RUN curl -o miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-py38_4.8.2-Linux-x86_64.sh &&\
# 	mkdir /build/.conda && \
# 	bash miniconda.sh -b -p /build/miniconda3 &&\
# 	rm -rf /miniconda.sh

RUN curl -o miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-py39_4.9.2-Linux-x86_64.sh &&\
		mkdir /build/.conda && \
		bash miniconda.sh -b -p /build/miniconda3 &&\
		rm -rf /miniconda.sh

ENV PATH="/build/miniconda3/bin:${PATH}"
ARG PATH="/build/miniconda3/bin:${PATH}"
RUN conda install pip
RUN pip install --upgrade pip

RUN apt-get update -y && \
apt-get install -y libsm6 libxext6 libxrender-dev

RUN pip install numpy==1.20.3 && \
pip install scipy==1.5.4 && \
pip install pandas==1.1.5 && \
pip install Pillow==8.1.2 && \
pip install imageio==2.9.0 && \
pip install scikit-learn==0.24.2 && \
pip install scikit-image==0.18.1 && \
pip install vedo==2020.3.2 && \
pip install pyvista==0.29.1 && \
pip install porespy==1.3.1 && \
pip install openpnm==2.7.0 && \
pip install pytrax==0.1.2 && \
pip install vtk==9.1.0 && \
pip cache purge

CMD /bin/bash
