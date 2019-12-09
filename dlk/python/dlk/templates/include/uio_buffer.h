/* Copyright 2018 The Blueoil Authors. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
==============================================================================*/

#pragma once
#include <sys/mman.h>
#include <stdint.h>
#include <fcntl.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>

#include <iostream>
#include <fstream>
#include <string>
#include <map>
#include <vector>

class UIO_Buffer
{

public:

  ~UIO_Buffer()
  {
    if(mm_buffer != nullptr)
    {
      munmap((void *) mm_buffer, mapped_size_in_bytes);
    }
  }


  std::string get_attribute(std::string& path)
  {
    std::ifstream in_file(path);
    if(!in_file)
    {
      std::cout << "Error: Opening file was failed in get_attribute() of UIO_Buffer" << std::endl;
      return std::string("");
    }

    std::string str_buf;
    if(!(in_file >> str_buf))
    {
      std::cout << "Error: Reading file was failed in get_attribute() of UIO_Buffer" << std::endl;
      return std::string(""); 
    }
    
    return str_buf;
  }


UIO_Buffer(const std::string &device_name, uint32_t size_in_bytes)  
    :
    mm_buffer(nullptr),
    mapped_size_in_bytes(size_in_bytes) 
{
    if(mm_buffer != nullptr)
    {
      std::cout << "Error: UIO_Buffer " << device_name << " already initalized" << std::endl;
      throw std::system_error(errno, std::generic_category());
    }

    const std::string device_file = "/dev/" + device_name;

    // open device and map the memory

    int dev_fd = open(device_file.c_str(), O_RDWR | O_SYNC);
    if(dev_fd < 0)
    {
      std::cout << strerror(errno) << std::endl;
      throw std::system_error(errno, std::generic_category());
    }

    std::string attribute = std::string("/sys/class/uio/")+device_name+std::string("/maps/map0/addr");
    std::string str_phys_adr = get_attribute(attribute);
    if(str_phys_adr == "")
    {
      std::cout << strerror(errno) << std::endl;
      throw std::system_error(errno, std::generic_category()); 
    }
    unsigned long physical_address = std::stoull(str_phys_adr, nullptr, 16);

    mm_buffer = mmap(
      nullptr,
      mapped_size_in_bytes,
      PROT_READ | PROT_WRITE,
      MAP_SHARED,
      dev_fd,
      physical_address // This parameter should be zero when udmabuf driver is used
    );

    close(dev_fd);
    if(mm_buffer == MAP_FAILED)
    {
      std::cout << "Error: " << strerror(errno) << std::endl;
      throw std::system_error(errno, std::generic_category());
    }

    memset((void *) mm_buffer, 0, mapped_size_in_bytes);

  }

  volatile void* buffer()
  {
    return mm_buffer;
  }


private:
  UIO_Buffer(const UIO_Buffer &);
  UIO_Buffer& operator=(const UIO_Buffer &);

private:
  volatile void *mm_buffer;
  uint32_t mapped_size_in_bytes;
};
