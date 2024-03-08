#/bin/bash -x
cat "$0" >&2 
model="unet3d_320"
loss="l2_loss"
datasets="feta3d_4_inpaint"
denoiser="nothing"
postfilt="nothing"
load="/homes/3/siy0/Developer/densefcnseg/checkpoints/brain3d_4_inpaint_unet3d_320_l2_loss_250k/last.ckpt"
train_metrics="MeanL2Loss"
valid_metrics="MeanL2Loss"
tests_metrics="MeanL2Loss"
batch_size=1
mode="--no_skip --train"
seed=0
drop=0.000
alpha=1.000
positional=0

for dataset in $datasets
do
    for mu in 0.000
    do
	gpu=0
	for theta in 0.000
	do
	    echo "(GPU $gpu) seed: $seed, launching batch_size: $batch_size"
	    remarks="$dataset"_"$model"_"$loss"_250k_192_temp #brain3d_inpaint_train_1000 #_no_skip
	    python train.py --trainee segment --dataset $dataset --denoiser $denoiser --postfilt $postfilt --mu $mu --theta $theta --alpha $alpha --batch_size $batch_size --valid_batch_size $batch_size --loss $loss --valid_metrics $valid_metrics --tests_metrics $tests_metrics --network  $model --seed $seed --max_steps 250000 --limit_val_batches 100 --drop $drop --optim adam --lr_start 1e-4 --momentum 0.90 --decay 0.0000 --schedule poly --load $load --val_check_interval 1.0 --monitor val_loss --monitor_mode min --seed $seed --remarks $remarks $mode > results/"$remarks".txt

	done
    done
done