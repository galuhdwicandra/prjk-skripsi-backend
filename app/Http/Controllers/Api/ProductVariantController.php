<?php
namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreVariantRequest;
use App\Http\Requests\UpdateVariantRequest;
use App\Models\Product;
use App\Models\ProductVariant;
use App\Services\Products\ProductService;
use Illuminate\Http\Request;

class ProductVariantController extends Controller
{
    public function __construct(private ProductService $svc)
    {}

    public function search(Request $req)
    {
        $this->authorize('viewAny', ProductVariant::class);

        $validated = $req->validate([
            'q'            => ['nullable', 'string', 'max:100'],
            'warehouse_id' => ['nullable', 'integer', 'min:1'],
            'gudang_id'    => ['nullable', 'integer', 'min:1'],
            'per_page'     => ['nullable', 'integer', 'min:1', 'max:50'],
            'page'         => ['nullable', 'integer', 'min:1'],
        ]);

        $term = trim((string) ($validated['q'] ?? ''));

        $warehouseId = $validated['warehouse_id'] ?? $validated['gudang_id'] ?? null;

        $perPage = (int) ($validated['per_page'] ?? 12);

        $query = ProductVariant::query()
            ->with([
                'product:id,nama,slug,is_active',
            ])
            ->where('is_active', true)
            ->whereHas('product', function ($productQuery) {
                $productQuery->where('is_active', true);
            });

        if ($term !== '') {
            $like = '%' . str_replace(['%', '_'], ['\\%', '\\_'], $term) . '%';

            $query->where(function ($searchQuery) use ($like) {
                $searchQuery
                    ->where('sku', 'ILIKE', $like)
                    ->orWhere('size', 'ILIKE', $like)
                    ->orWhere('type', 'ILIKE', $like)
                    ->orWhere('tester', 'ILIKE', $like)
                    ->orWhereHas('product', function ($productQuery) use ($like) {
                        $productQuery
                            ->where('nama', 'ILIKE', $like)
                            ->orWhere('slug', 'ILIKE', $like);
                    });
            });
        }

        if (! empty($warehouseId)) {
            $query->withSum([
                'stocks as stock_qty' => function ($stockQuery) use ($warehouseId) {
                    $stockQuery->where('gudang_id', (int) $warehouseId);
                },
            ], 'qty');
        }

        $paginator = $query
            ->orderByDesc('id')
            ->paginate($perPage);

        $data = $paginator->getCollection()->map(function (ProductVariant $variant) {
            $productName = $variant->product?->nama ?? '';

            return [
                'id'         => $variant->id,
                'product_id' => $variant->product_id,
                'sku'        => $variant->sku,
                'harga'      => (float) $variant->harga,
                'nama'       => $productName,
                'full_name'  => trim(collect([
                    $productName,
                    $variant->size,
                    $variant->type,
                    $variant->tester,
                ])->filter()->implode(' ')),
                'stock_qty'  => (int) ($variant->stock_qty ?? 0),
                'image_url'  => $variant->product?->image_url,
                'media_path' => null,
            ];
        })->values();

        return response()->json([
            'data'         => $data,
            'current_page' => $paginator->currentPage(),
            'per_page'     => $paginator->perPage(),
            'total'        => $paginator->total(),
            'last_page'    => $paginator->lastPage(),
            'meta'         => [
                'current_page' => $paginator->currentPage(),
                'per_page'     => $paginator->perPage(),
                'total'        => $paginator->total(),
                'last_page'    => $paginator->lastPage(),
            ],
            'message'      => 'OK',
            'errors'       => [],
        ]);
    }

    // List varian by product
    public function index(Product $product)
    {
        $this->authorize('view', $product);

        $items = $product->variants()->orderByDesc('id')->get();

        return response()->json([
            'data' => $items,
        ]);
    }

    // Create varian
    public function store(StoreVariantRequest $request, Product $product)
    {
        $this->authorize('update', $product);

        $variant = $this->svc->createVariant($product, $request->validated());

        return response()->json([
            'message' => 'Variant created',
            'data'    => $variant,
        ], 201);
    }

    // Show varian
    public function show(Product $product, ProductVariant $variant)
    {
        $this->authorize('view', $product);
        $this->authorize('view', $variant);

        // Opsional: validasi varian milik product
        abort_unless($variant->product_id === $product->id, 404);

        return response()->json($variant);
    }

    // Update varian
    public function update(UpdateVariantRequest $request, Product $product, ProductVariant $variant)
    {
        $this->authorize('update', $product);
        $this->authorize('update', $variant);
        abort_unless($variant->product_id === $product->id, 404);

        $updated = $this->svc->updateVariant($variant, $request->validated());

        return response()->json([
            'message' => 'Variant updated',
            'data'    => $updated,
        ]);
    }

    // Delete varian
    public function destroy(Product $product, ProductVariant $variant)
    {
        $this->authorize('update', $product);
        $this->authorize('delete', $variant);
        abort_unless($variant->product_id === $product->id, 404);

        $this->svc->deleteVariant($variant);

        return response()->json(['message' => 'Variant deleted']);
    }
}
