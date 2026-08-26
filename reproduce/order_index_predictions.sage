covol_T7 = 0.888914927816353
vol_m009 = 2.66674478344906
vol_m010 = 2.66674478344906  # equal volumes, confirmed earlier this session

# m009: level n = Pbar^2 (v_P=0, v_Pbar=4 => level exponents 0,2)
# index [PSL2(OK):Gamma_0(Pbar^2)] = N(Pbar)^2 + N(Pbar)^1 = 4+2 = 6
idx_Gamma0_m009 = 2**2 + 2**1
covol_Gamma0_m009 = idx_Gamma0_m009 * covol_T7
print("m009: level = Pbar^2, [PSL2(OK):Gamma_0]=", idx_Gamma0_m009,
      " covol(Gamma_0)=", covol_Gamma0_m009)
# single prime dividing level -> 1 Atkin-Lehner involution -> normalizer index 2
covol_N_m009 = covol_Gamma0_m009 / 2
print("m009: covol(N(R)) [AL index 2] =", covol_N_m009)
print("m009: vol(m009)/covol(N(R)) =", vol_m009 / covol_N_m009)

print()

# m010: level n = P^2 * Pbar^2 = (4), two independent prime-power factors
idx_Gamma0_m010 = (2**2 + 2**1) * (2**2 + 2**1)
covol_Gamma0_m010 = idx_Gamma0_m010 * covol_T7
print("m010: level = P^2*Pbar^2 = (4), [PSL2(OK):Gamma_0]=", idx_Gamma0_m010,
      " covol(Gamma_0)=", covol_Gamma0_m010)
# two distinct primes dividing level -> up to 4 AL involutions (Z/2 x Z/2)
covol_N_m010 = covol_Gamma0_m010 / 4
print("m010: covol(N(R)) [AL index 4] =", covol_N_m010)
print("m010: vol(m010)/covol(N(R)) =", vol_m010 / covol_N_m010)
