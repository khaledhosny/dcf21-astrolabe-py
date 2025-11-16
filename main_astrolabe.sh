#!/bin/bash
# main_astrolabe.sh
# -*- coding: utf-8 -*-
#
# The bash script in this file makes the various parts of a model astrolabe.
#
# Copyright (C) 2010-2023 Dominic Ford <https://dcford.org.uk/>
#
# This code is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation; either version 2 of the License, or (at your option) any later
# version.
#
# You should have received a copy of the GNU General Public License along with
# this file; if not, write to the Free Software Foundation, Inc., 51 Franklin
# Street, Fifth Floor, Boston, MA  02110-1301, USA

# ----------------------------------------------------------------------------

# Delete any previous output from running this script
rm -Rf __pycache__ *.pyc output
rm -Rf doc/*.aux doc/*.dvi doc/*.log doc/*.pdf doc/*.ps doc/tmp doc/*.out

# Run the python 3 script which generates astrolabe models for a wide range of latitudes
for lat in $(seq -80 5 90); do
	# Do not make equatorial astrolabes, as they don't really work
	if [ -10 -lt $lat -a $lat -lt 10 ]; then continue; fi

	python3 -m astrolabe --latitudes "$lat" --types full simplified --formats pdf svg png
done

pushd output/astrolabes
for ltx in *.tex; do
	for pass in $(seq 3); do
		pdflatex $ltx
	done
done

for pdf in *_en_full.pdf; do
	ln -s $pdf ${pdf//_en_full/};
done
popd

# Clean up temporary files which get made along the way
rm -Rf __pycache__ *.pyc
rm -Rf output/astrolabes/*.{aux,dvi,log,ps,out}
