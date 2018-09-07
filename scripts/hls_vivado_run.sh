#!/bin/bash
if [ "$1" == "-h" ]; then
  echo "Usage: `basename $0` l1menu_path l1menu_name vivado_version build_dir build_nr"
  exit 0
fi
username=herbberg
tag=master
l1menu_path="$1"
echo $l1menu_path
l1menu_name="$2"
echo $l1menu_name
vivado_version="$3"
echo $vivado_version
build_dir="$4"
echo $build_dir
build="$5"
echo $build
echo ""
echo "------------------"
git clone https://github.com/$username/hls4gtl ~/$build_dir/hls4gtl
cd ~/$build_dir/hls4gtl
git checkout $tag
python utils/distribute.py ~/$l1menu_path/$l1menu_name/xml/$l1menu_name.xml
cd
git clone https://github.com/$username/mp7ugt_hls ~/$build_dir/mp7ugt_hls
python ~/$build_dir/mp7ugt_hls/scripts/makeProject.py -t mp7fw_v2_4_1 -u hbergaue -b 0x$build -m ~/$l1menu_path/$l1menu_name --hls ~/$build_dir/hls4gtl/hls_impl/solution1/impl/ip -p ~/$build_dir/work
cd ~/$build_dir/hls4gtl
python ~/$build_dir/mp7ugt_hls/scripts/startSynth.py $vivado_version ~/$build_dir/work/mp7_ugt/0x$build/mp7fw_v2_4_1/build/build_0x$build.cfg
