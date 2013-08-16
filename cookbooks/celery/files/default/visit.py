from celery.task.http import URL
import getopt, sys

def main():
    try:
        opts, args = getopt.getopt(sys.argv[1:], "hu:", ["help", "url="])
    except getopt.GetoptError as err:
        # print help information and exit:
        print(err) # will print something like "option -a not recognized"
        usage()
        sys.exit(2)
    filename = False
    for o, a in opts:
        if o in ("-h", "--help"):
            usage()
            sys.exit()
        elif o in ("-u", "--url"):
            url = a
            res = URL(url).get_async()

if __name__ == "__main__":
    main()
