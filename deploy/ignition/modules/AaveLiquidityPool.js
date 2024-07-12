const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("AaveLiquidityPoolModule", (m) => {
  // https://docs.aave.com/developers/deployed-contracts/v3-testnet-addresses
  const addressesProvider = m.getParameter(
    "_addressesProvider",
    "0x012bac54348c0e635dcac9d5fb99f06f24136c9a"
  );

  const AaveLiquidityPool = m.contract("AaveLiquidityPool", [
    addressesProvider,
  ]);

  return { AaveLiquidityPool };
});

// #AaveLiquidityPool - 0x1831C6Ca1AE97D218262300b60386Ea5729F626F
