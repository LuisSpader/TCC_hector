echo "##############################################################################"
echo "Deleting result files:"

find ./MAC_Operators/ -name "results*"
find ./MAC_Operators/ -name "results*" -type f -delete

echo ""

find ./MAC_Spiral_Compressors/ -name "results*"
find ./MAC_Spiral_Compressors/ -name "results*" -type f -delete

echo "##############################################################################"