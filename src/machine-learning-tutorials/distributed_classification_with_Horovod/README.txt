A tutorial example on usage of distributed training framework Horovod.

In this tutorial we will take a simple MNIST classification model training in Keras and use Horovod to distribute dataset processing workload among several GPUs.

Check the tutorial.ipynb notebook for detailed explanations on the modifications you need to do to migrate from centralized to distributed training.

Run the centralized training from terminal: 
	python centralized_train.py

Run distributed training with 2 GPUs on one host from teminal:
	horovodrun -np 2 -H localhost:2 python distributed_train.py

In case you see a lot of erroneous console output, you can filter it out with grep -v "Read -1" like:
	horovodrun -np 2 -H localhost:2 python distributed_train.py |& grep -v "Read -1"

Requirements:
	- Python3
	- Tensorflow2
	- Keras
	- Horovod
