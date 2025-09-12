// Unformatted code, that should fail formatting checks

#include<array>
   #include    <cassert>
#include <numeric>

    namespace  Math
    {
    auto sqr   ( const   int x)->int     {
return x       * x;
}
    } // namespace Math

    auto   main(    ) ->int{
    constexpr   std::size_t     ARRAY_SIZE=10;
    std::array<  int,ARRAY_SIZE  >array={};
    std::iota(
            array.begin(),
            array.end(),
            1
);

    for (std::size_t i = 0;
         i < ARRAY_SIZE; ++i)
    {
        assert(
                Math::sqr(array.at(i))==array.at( i )*array.at( i )
            );
    }

    return 0;}