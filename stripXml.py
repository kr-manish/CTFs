from lxml import etree as ET
import argparse
import sys

#fil1 = sys.argv[1]
#fil2 = sys.argv[2]

def parseXml(fil1, fil2):
    tree = ET.parse(fil1)
    notag = ET.tostring(tree, pretty_print=True, encoding='utf8', method='text')
    #print(notag)
    with open(fil2, 'w') as f:
        f.write(notag)

def arg_parser():
    parser = argparse.ArgumentParser()
    parser.add_argument("xml", help="path to input xml file")
    parser.add_argument("output", help="path to output file")
    args = parser.parse_args()
    return args


if __name__ == '__main__':
    args = arg_parser()
    fil1 = args.xml
    fil2 = args.output
    parseXml(fil1, fil2)
