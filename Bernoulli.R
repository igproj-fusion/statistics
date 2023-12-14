library(rstan)

# generates data for simulation 
#
N <- 1000
p <- 0.508
dat <- rbinom(N, 1, p)


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
  real<lower = 0, upper = 1> p;
}

model {
  for (i in 1:n)
    x[i] ~ bernoulli(p);
}
"

mod <- stan_model(model_code = stancode, verbose = TRUE)
d <- list(n = N, x = dat)
fit <- sampling(mod, d,
                chains = 4, iter = 2000, 
                warmup = 1000, thin = 1)
print(fit)


# Computes confidence intervals 
#
binom.test(sum(dat), N)
