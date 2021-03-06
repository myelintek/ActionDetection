FROM nvidia/cuda:10.2-cudnn7-devel-ubuntu18.04

ENV SHELL /bin/bash
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64
ENV DEBIAN_FRONTEND=noninteractive
ARG VERSION
ENV VERSION ${VERSION:-dev}

WORKDIR /mlsteam/lab

ADD clean-layer.sh requirements.txt requirements.system install-sshd.sh set_terminal_dark.sh /tmp/

RUN sed -i 's/archive.ubuntu.com/tw.archive.ubuntu.com/g' /etc/apt/sources.list && \
    mkdir -p /mlsteam/data && \
    mkdir -p /mlsteam/lab && \
    apt-get update && \
    xargs apt-get install -y < /tmp/requirements.system && \
    pip3 install --no-cache-dir -r /tmp/requirements.txt && \
    bash /tmp/install-sshd.sh && \
    bash /tmp/set_terminal_dark.sh && \
    bash /tmp/clean-layer.sh
    
RUN pip3 install -U torch==1.5.1+cu101 torchvision==0.6.1+cu101 -f https://download.pytorch.org/whl/torch_stable.html

RUN pip3 install mmcv-full==1.2.7+torch1.5.0+cu101 -f https://download.openmmlab.com/mmcv/dist/index.html

RUN pip3 install --upgrade https://github.com/myelintek/lib-mlsteam/releases/download/v0.3/mlsteam-0.3.0-py3-none-any.whl

ADD src /mlsteam/lab

ADD bash.bashrc /etc/bash.bashrc

RUN pip3 install ipywidgets --user

RUN mc config host add ms3 https://s3.myelintek.com minioadmin 83536253  && \ 
	mc mirror --overwrite ms3/kinetics400-tiny/ /mlsteam/data/ && \
	cd /mlsteam/lab && \
    jupyter nbconvert --to notebook --inplace --execute entry.ipynb && \
	rm -rf /mlsteam/data/*

RUN rm -rf /usr/lib/x86_64-linux-gnu/libcuda.so /usr/lib/x86_64-linux-gnu/libcuda.so.1 /tmp/*

