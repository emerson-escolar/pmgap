#!/usr/bin/env python3

import argparse
import json
import sys

def argument_parser():
    p = argparse.ArgumentParser(description="Convert Homcloud random-cech program (https://bitbucket.org/tda-homcloud/random-cech/src/master/) to pmgap json format. Spits output to standard out.")

    p.add_argument("input", help = "input filename")
    return p


class Main(object):
    def __init__(self, args):
        self.args = args
        self.filtration = None

    def run(self):
        self.filtration = Filtration.create_from_file(self.args.input)
        json_ans = {
            "rows": self.filtration.max_n,
            "cols": self.filtration.max_m,
            "cells": self.filtration.simplices}
        json.dump(json_ans, sys.stdout)


class Filtration:
    def __init__(self):
        self.simplices = []
        self.max_n = 0
        self.max_m = 0

    @staticmethod
    def create_from_file(fname):
        ans = Filtration()

        vertex_set_to_simplex_index = {}

        with open(fname, 'r') as ifile:
            header = ifile.readline()
            cur_index = 0
            for line in ifile:
                data = line.split()
                dim = int(data[0])
                assert(len(data) == 4+dim+1)

                birth = float(data[1])
                n = int(data[2])+1
                m = int(data[3])+1
                ans.max_n = max(n, ans.max_n)
                ans.max_m = max(m, ans.max_m)
                vertices = data[4:4+dim+1]

                boundary = []
                if dim > 0:
                    boundary = [vertex_set_to_simplex_index[frozenset(vertices[:j] + vertices[j+1:])] for j in range(dim+1)]

                ans.simplices.append({"d":dim, "t":[n,m],"b":boundary})
                vertex_set_to_simplex_index[frozenset(vertices)] = cur_index
                cur_index += 1
        return ans


def main(args):
    Main(args).run()

if __name__ == "__main__":
    main(argument_parser().parse_args())
