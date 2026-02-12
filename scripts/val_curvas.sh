#!/bin/bash
# test a model to segment abdominal/cardiac MRI
GPUID1=0
export CUDA_VISIBLE_DEVICES=$GPUID1

###### Shared configs ######
DATASET='CURVAS_TEST'
#DATASET='CMR'
NWORKER=16
RUNS=1
ALL_EV=(0) # 5-fold cross validation (0, 1, 2, 3, 4)
TEST_LABEL='[2]'
###### Training configs ######
NSTEP=30000
DECAY=0.98

MAX_ITER=1000 # defines the size of an epoch
SNAPSHOT_INTERVAL=10000 # interval for saving snapshot
SEED=2021

N_PART=1 # defines the number of chunks for evaluation
ALL_SUPP=(2) # CHAOST2: 0-4, CMR: 0-7
RATER=1
echo ========================================================================

EVAL_FOLD=0

PREFIX="test_${DATASET}_cv${EVAL_FOLD}"
echo $PREFIX
LOGDIR="./results"

if [ ! -d $LOGDIR ]
then
  mkdir -p $LOGDIR
fi
SUPP_IDX=-1
    # RELOAD_PATH='please feed the absolute path to the trained weights here' # path to the reloaded model
    RELOAD_MODEL_PATH="/home/khoi.ho/MICCAI_26/benchmarks/Q-Net/exps_on_CURVAS_multi_91/QNet_train_CURVAS_cv0/5/snapshots/50000.pth"
    python3 test.py with \
    mode="test" \
    dataset=$DATASET \
    num_workers=$NWORKER \
    n_steps=$NSTEP \
    eval_fold=$EVAL_FOLD \
    max_iters_per_load=$MAX_ITER \
    supp_idx=$SUPP_IDX \
    test_label=$TEST_LABEL \
    seed=$SEED \
    n_part=$N_PART \
    reload_model_path=$RELOAD_MODEL_PATH \
    save_snapshot_every=$SNAPSHOT_INTERVAL \
    lr_step_gamma=$DECAY \
    path.log_dir=$LOGDIR \
    rater=$RATER


