# libifcb
A native Python library and CLI tool for working with IFCB data.

Image Dataset Container

## What can libifcb do?

libifcb supports exporting to and importing annotations from EcoTaxa.
libifcb supports exporting both annotated and unannotated data to Parquet format.
libifcb supports exporting annotation information to CSV and JSON.
libifcb can combine containers and perform splits based on various criteria.

## Quick start

Start by importing your data into the HD5 working file format
`ifcbtool.py import ifcb --hdr *.hdr --adc *.adc --roi *.roi -o example.h5`
*OR*
`ifcbtool.py import ifcb *.hdr *.adc *.roi -o example.h5`

**Note:** IFCBtool will take a hdr, adc and roi file in turn, in order of specification. This will usually just work, but don't manually specify files out-of-order! That will almost certainly throw an error.

## EcoTaxa integration

Start by creating an upload payload for EcoTaxa.
`ifcbtool.py export ecotaxa example.h5 [--diff existing.tsv] -o upload.zip`
**Note:** Adding a diff file will skip samples already present in the EcoTaxa project defined by the TSV file.

Once you've annotated data in EcoTaxa, export the TSV file and import it back into the HDF5 container.
`ifcbtool.py import ecotaxa annotations.tsv -o example.h5`

Now you're ready to export the annotated dataset for further use!

## HDF5 format definition

Samples:
| --- | --- | --- |
| imaging_timestamp | string | Will be in ISO UTC format (e.g. 20250509T110439Z). This will be the same date as indicated on a file right out of the IFCB. This will always be the time where the sample was imaged |
| instrument_id | string | Will be in format (IFCBxxx) |
| image_format | string | PIL image format string (default: L) |
| optical_mass_pmt_v_threshold | float | Voltage threshold for PMTA |
| chlorophyl_pmt_v_threshold | float | Voltage threshold for PMTB |
| collection_timestamp | string | Will be in ISO UTC format (e.g. 20250509T110439Z) if present. Optional parameter if sample collection time is different from imaging time, for example in the case of preserved samples |
| comment | string | Optional parameter used to comment on the sample |
| x_<name> | string | Any unrecognised parameters from source data |

Annotation Classes:
| --- | --- | --- |
| class_id | int | Arbitrary internal id |
| class_uri | string | SHOULD be a URI (not LSID) to a recognised taxonomic database (e.g. WoRMS, GBIF) OR a URL-safe string |
| parent_class_id | int | Parent class or -1 for no parent (Biota or non-life) |

Annotation Authors:
| --- | --- | --- |
| author_id | int | Arbitrary internal id |
| author_email | string | Optional email for author |
| author_name | string | Optional name for author |
| is_human | bool | Indicates wether this is a manually annotated annotation |
| parent_class_id | int | Parent class or -1 for no parent (Biota or non-life) |

Annotations:
| --- | --- | --- |
| class_id | int | Cross reference to the class, -1 for unclassified |
| roi_index | int | Cross reference to the ROI index |
| author_id | int | Cross reference for author ID |
| annotation_timestamp | string | Will be in ISO UTC format (e.g. 20250509T110439Z). |

Then for each Sample:

Triggers:
| --- | --- | --- |
| trigger_index | int | Trigger number in sample |
| optical_mass_pmt_v | float | Voltage recorded by PMTA |
| chlorophyl_pmt_v | float | Voltage recorded by PMTB |

ROIs:
| --- | --- | --- |
| trigger_index | int | The trigger number that caused the ROI to be taken |
| roi_index | int | The ROI number in sample |
| image_width | int | Width in pixels |
| image_height | int | Height in pixels |
| image_data | uint8array | ROI image data |
