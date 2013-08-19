from celery.task.http import URL
import getopt, sys

def main():
    try:
        opts, args = getopt.getopt(sys.argv[1:], "hu:f:", ["help", "url=", "file="])
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
        elif o in ("-f", "--file"):
            filename = a
        elif o in ("-u", "--url"):
            url = a

    res = URL(url)
    res.query['n'] = filename
    print(str(res))
    new_res = res.post_async()
    print(new_res.get())
if __name__ == "__main__":
    main()
