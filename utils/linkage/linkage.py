import numpy as np


# define function to calculate linkage quality
def calculate_linkage_quality(anon_data, ext_data):
    # find individuals in anonymized data with same occupation as individuals in external data
    matched_rows = set()
    for i in range(len(ext_data)):
        matches = []
        for j in range(len(anon_data)):
            if all(ext_data[i, k] == anon_data[j, k] for k in range(ext_data.shape[1])):
                matches.append(j)
        matched_rows.update(matches)

    # calculate linkage quality
    matched_pairs = []
    for i in matched_rows:
        for j in matched_rows:
            if i != j and (i, j) not in matched_pairs and (j, i) not in matched_pairs:
                if all(anon_data[i, k] == anon_data[j, k] for k in range(anon_data.shape[1])):
                    matched_pairs.append((i, j))
    linkage_quality = len(matched_pairs) / len(ext_data)

    return linkage_quality
