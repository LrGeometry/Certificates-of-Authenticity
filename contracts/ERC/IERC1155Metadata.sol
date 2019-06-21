/*Copyright (c) 2019-2552 Hercules SEZC Licensed under the Apache License, Version 2.0 (the "License");you may not use this file except in compliance with the License.You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing, softwaredistributed under the License is distributed on an "AS IS" BASIS,WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.See the License for the specific language governing permissions andlimitations under the License.*/
pragma solidity ^0.5.0;

interface IERC1155Metadata_URI {
    /**
        @notice A distinct Uniform Resource Identifier (URI) for a given token
        @dev URIs are defined in RFC 3986
        @return  URI string
    */
    function uri(uint256 _id) external view returns (string memory);
}

interface IERC1155Metadata_Name {
    /**
        @notice A distinct Uniform Resource Identifier (URI) for a given token
        @dev URIs are defined in RFC 3986
        @return  URI string
    */
    function name(uint256 _id) external view returns (string memory);
}
