// SPDX-License-Identifier: MIT

pragma solidity ^0.8.2;

import "./LzAppUpgradeable.sol";
import "../../util/ExcessivelySafeCall.sol";
import "./NonblockingLzAppUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

/*
 * the default LayerZero messaging behaviour is blocking, i.e. any failed message will block the channel
 * this abstract class try-catch all fail messages and store locally for future retry. hence, non-blocking
 * NOTE: if the srcAddress is not configured properly, it will still block the message pathway from (srcChainId, srcAddress)
 */
abstract contract NonblockingLzAppUpgradeableOwnable is Initializable, NonblockingLzAppUpgradeable, OwnableUpgradeable {
    using ExcessivelySafeCall for address;

    function __NonblockingLzAppUpgradeableOwnable_init(address _endpoint) internal onlyInitializing {
        __Ownable_init_unchained();
        __NonblockingLzAppUpgradeable_init_unchained(_endpoint);
    }

    function __NonblockingLzAppUpgradeableOwnable_init_unchained(address _endpoint) internal onlyInitializing {}

    // generic config for LayerZero user Application
    function setConfig(uint16 _version, uint16 _chainId, uint _configType, bytes memory _config) external override onlyOwner {
        _setConfig(_version, _chainId, _configType, _config);
    }

    function setSendVersion(uint16 _version) external override onlyOwner {
        _setSendVersion(_version);
    }

    function setReceiveVersion(uint16 _version) external override onlyOwner {
        _setReceiveVersion(_version);
    }

    function forceResumeReceive(uint16 _srcChainId, bytes memory _srcAddress) external override onlyOwner {
        _forceResumeReceive(_srcChainId, _srcAddress);
    }

    // _path = abi.encodePacked(remoteAddress, localAddress)
    // this function set the trusted path for the cross-chain communication
    function setTrustedRemote(uint16 _srcChainId, bytes memory _path) external onlyOwner {
        _setTrustedRemote(_srcChainId, _path);
    }

    function setTrustedRemoteAddress(uint16 _remoteChainId, bytes memory _remoteAddress) external onlyOwner {
        _setTrustedRemoteAddress(_remoteChainId, _remoteAddress);
    }

    function setPrecrime(address _precrime) external onlyOwner {
        _setPrecrime(_precrime);
    }

    function setMinDstGas(uint16 _dstChainId, uint16 _packetType, uint _minGas) external onlyOwner {
        _setMinDstGas(_dstChainId, _packetType, _minGas);
    }

    // if the size is 0, it means default size limit
    function setPayloadSizeLimit(uint16 _dstChainId, uint _size) external onlyOwner {
        _setPayloadSizeLimit(_dstChainId, _size);
    }
}
