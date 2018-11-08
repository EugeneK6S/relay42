# How To:

1. Pre-req (just an example; obviously, you won't be able to do it, since it's in a private repo):
```
cd app/
docker build -t kabae/relay42-test:latest .
docker push kabae/relay42-test:latest
```
```
cd backend/
docker build -t kabae/relay42-date:latest .
docker push kabae/relay42-date:latest
```

2. Strap the infra:
```
terraform init
terraform apply
```

3. Get the output:
```
ecsLoadBalancer-name = relayALB-2036734004.eu-central-1.elb.amazonaws.com
```

4. Browse: 
http://relayALB-2036734004.eu-central-1.elb.amazonaws.com/hello


# Potential improvements:

1. HTTPS
2. Multi-region
