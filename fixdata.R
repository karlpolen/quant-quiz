##  add indices to data file
data=read.csv('returns.csv')
start=as.Date("2014-3-31")
end=as.Date("2019-3-31")
tickers=c("SPXT Index","LBUSTRUU Index","US0003M Index","BCOMTR Index")
field="PX_LAST"
Sys.setenv(JAVA_HOME='')
library(Rbbg)
conn=blpConnect()
bbgdat=bdh(conn,tickers,field,start_date=start,end_date=end,
           option_names="periodicitySelection",option_values="MONTHLY")
x=blpDisconnect(conn)
library(tidyr)
bbgdat2=spread(bbgdat,ticker,PX_LAST)
Commodities=bbgdat2[,"BCOMTR Index"]
Commodities=-1+exp(diff(log(Commodities)))
Stocks=-1+exp(diff(log(bbgdat2[,"SPXT Index"])))
Bonds=-1+exp(diff(log(bbgdat2[,"LBUSTRUU Index"])))
Cash=bbgdat2[-1,"US0003M Index"]/1200
data=cbind(data,Cash,Stocks,Bonds,Commodities)
write.csv(data,file="asset_returns.csv")
