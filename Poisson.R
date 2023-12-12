library(DescTools)
library(rstan)

# generates data for simlation 
#
set.seed(1)
N <- 200
Lamda <- 5
dat <- rpois(n = N, lambda = Lamda)


# Computes confidence intervals by "DescTools"
#
PoissonCI(x = sum(dat), n = N, method = c("exact", "score", "wald", "byar"))


# estimates parameters by Rstan
#
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

stancode <- 
"
data {
    int n;
    int x[n];
}
parameters {
    real lambda;
}
model {
    x ~ poisson(lambda);
}
"

mod <- stan_model(model_code = stancode, verbose = TRUE)
d <- list(x = dat, n = N)
fit <- sampling(mod, d,
                chains = 4, iter = 2000, 
                warmup = 1000, thin = 1)
print(fit)
