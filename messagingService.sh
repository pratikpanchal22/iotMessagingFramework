#!/bin/bash

#INITIALIZATIONS
PAYLOAD="<empty>";
MODE="unknown";
DEST="unknown";

###########################
#GET OPTIONS
###########################
while getopts ":p:d:hTL" opt; do
    case $opt in
    p)
        PAYLOAD=$OPTARG >&2
        #echo ">>> Payload: " $PAYLOAD
        ;;
    d)
        DEST=$OPTARG >&2
        #echo ">>> Destination: " $OPTARG >&2
        ;;
    ### FLAGS
    h)
        echo "Options:"
        echo " -p 'payload'"
        echo " -d 'destination 10 digit phone number'"
        echo "Flags:"
        echo " -T (trial mode)"
        echo " -L (live mode)"
        echo " -h (help)"
        exit 1
        ;;
    T)
        MODE="TRIAL"; 
        ;;
    L)
        MODE="LIVE"; 
        ;;
    ### UNKNONWS
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
    esac
done

###########################
#MESSAGING SERVICE MODE
#DEFAULT MODE = TRIAL
###########################
if [ $MODE = "unknown" ]
then
   MODE="TRIAL";
fi
#echo ">>> Messaging service mode: "$MODE

###########################
#VALIDATION CHECK
#DESTINATION PHONE NUMBER
###########################
if [ $DEST = "unknown" ]
then
   echo "Error: Destination 10 digit phone number required (-d)"
   exit 1
fi
re='^[0-9]+$'
if ! [[ $DEST =~ $re ]] ; then
   echo "Error: Destination phone is not a number:" $DEST; 
   exit 1
fi

if ! [ ${#DEST} -eq 10 ] 
then 
   echo "Error: Destination phone is not a 10 digit number"; 
   exit 1
fi

###########################
#TWILIO CREDENTIALS
###########################
TEST_ACCOUNT_SID="dummyTestAccountSid";
TEST_AUTH_TOKEN="dummyAuthToken";
TEST_FROM="From=+15005550006";
TEST_TOKEN="$TEST_ACCOUNT_SID:$TEST_AUTH_TOKEN";

LIVE_ACCOUNT_SID="dummyLiveAccountSid";
LIVE_AUTH_TOKEN="dummyLiveAuthToken";
LIVE_FROM="From=+15005550006";
LIVE_TOKEN="$LIVE_ACCOUNT_SID:$LIVE_AUTH_TOKEN";


###########################
#MESSAGING MODE PARAMETERS
###########################

if [ $MODE = "TRIAL" ]
then
   URL="https://api.twilio.com/2010-04-01/Accounts/"$TEST_ACCOUNT_SID"/Messages.json";
   TOKEN=$TEST_TOKEN;
   FROM=$TEST_FROM;
fi

if [ $MODE = "LIVE" ]
then
   URL="https://api.twilio.com/2010-04-01/Accounts/"$LIVE_ACCOUNT_SID"/Messages.json";
   TOKEN=$LIVE_TOKEN;
   FROM=$LIVE_FROM;
fi

DEST="To=+1"$DEST;

#Format Date
D=`date '+%Y-%m-%d %H:%M:%S'`;
#echo "Timestamp: " $D;
FORMATTED_PAYLOAD=$"Body="$PAYLOAD" "$D;
FORMATTED_TWITTER_PAYLOAD=$PAYLOAD" "$D;
#echo $FORMATTED_PAYLOAD

###########################
#MAKE REST WS CALL
###########################
#curl "$URL" -X POST --data-urlencode "$DEST" --data-urlencode "$FROM" --data-urlencode """$FORMATTED_PAYLOAD""" -u $LIVE_TOKEN
curl "$URL" -X POST \
--data-urlencode "$DEST" \
--data-urlencode "$FROM" \
--data-urlencode "$FORMATTED_PAYLOAD" \
-u $TOKEN --trace-ascii /dev/stdout 

###########################
# Also tweet
###########################
#python ./twitterService.py "$FORMATTED_TWITTER_PAYLOAD" >> log.log