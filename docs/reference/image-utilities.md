# Image utilities

We have two CLI utilities for image scraping and grooming:

- `image-scraper.py`: Scrape images from the web based on a list of keywords.
- `image-groomer.py`: Groom and preprocess images for machine learning tasks.

## Project information

- [:material-account-group: Main author - HEIA-FR](https://www.hes-so.ch/swiss-ai-center/equipe)
- [:material-git: Code](https://github.com/swiss-ai-center/image-groomer)

## Description

This package provides utilities for image scraping and grooming. It is designed to prepare datasets for machine learning tasks such as image classification, object detection, and image generation.

The `image-scraper.py` script allows users to scrape images from the web based on a list of keywords, while the `image-groomer.py` script provides functionalities for grooming and preprocessing images, including resizing, cropping, and format conversion.

### Image Scraper

This script is an image bulk downloader. It downloads large numbers of
images from urls obtained with a search engine (in this case Bing Image
Search) based on a search keyword or a list of keywords. This script
automates the process of downloading and organizing large sets of images
for composing datasets, with deduplication and multi-threading support.

Features:

- Bulk image downloading from Bing Image Search.
- Supports adult content filtering, applied per default, use `--no-adult-filter` to remove.
- Can apply Bing search filters (e.g., image size).
- Handles corrupted images and duplicate downloads.
- Can process multiple keywords from a file, saving each set in a separate subdirectory.
- gif files are blocked by default, use `--allow-gif` to allow them.
- Multi-threaded downloading for speed.

Example usage:

`python image-scraper.py -v -s "cat" --limit 100 -o data_raw/cat --allow-gif`

### Image Groomer

Simple utility to groom large set of images. While not limited to, the tools
available in the groomer are targeting the preparation of training and
evaluation sets in the context of classification tasks. It can provide simple
statistics on a set of images, detect strict or perceptual duplicates, perform
resizing and stratification into subsets (train, validation, test).

The set of images to process is defined either in one or more
paths or in one or more files. In "stat" mode, it just computes some stats
on the images. In "label" mode, it launches a simple labeling tool that
will let the user inspect the images and move them according to the class
labels defined in the label dictionary passed as argument.

The application hosts several modes:

- **stat**: Compute statistics on a set of images. Examples:
  `python3 image-groomer.py -v -m stat ~/my_dir/raw_data/*`

- **detect_same**: Detect identical images, optionnaly remove them
  with the flag `-rs`, or visualize duplicates with the flag `-i`. Example:
  `python3 image-groomer.py -r -m detect_same my_dir/my_category > tmp.txt`.

- **detect_similar**: Same as previous mode but detect similar images
  (resized, partial blurring etc) with perceptual hashing.

- **label**: Launch a simple TkInter labeller allowing
  to quickly label images in the categories defined above. Example:
  `python3 image-groomer.py -v -m label ~/my_dir/raw_data/tmp`
  
- **make_uniform**: Make the images uniform by converting all files to
  RGB, jpg compression, and optionally to a same size along width, height or
  both. It also includes different options for renaming the files in a
  consistent way.
  
- **make_sets**: Take a source directory containing categories of images
  and split it into train, validation and test sets. The split preserves the
  class balance. Default split sizes are, respectively, 80%, 10% and 10%.
  Example source directory:

  ```text
  unsplit_data_dir
  ├───category_a
  │   └───... 
  ├───category_b
  │   └───... 
  └───category_c
      └───...
      ...
  ```

  Result after data sets creation:

  ```text
  split_data_dir
  ├───test
  │   ├───category_a
  │   ├───category_b
  │   └───category_c
  |   ...
  ├───train
  │   ├───category_a
  │   ├───category_b
  │   └───category_c
  |   ...
  └───validate
  │   ├───category_a
  │   ├───category_b
  │   └───category_c
  |   ...
  ```
  