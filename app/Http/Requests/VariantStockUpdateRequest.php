<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class VariantStockUpdateRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    protected function prepareForValidation(): void
    {
        $nullableIntegerFields = [
            'min_stok',
            'safety_stock',
            'lead_time_days',
            'reorder_point',
        ];

        foreach ($nullableIntegerFields as $field) {
            if ($this->has($field) && $this->input($field) === '') {
                $this->merge([
                    $field => null,
                ]);
            }
        }
    }

    public function rules(): array
    {
        return [
            'min_stok'       => ['sometimes', 'nullable', 'integer', 'min:0'],
            'safety_stock'   => ['sometimes', 'nullable', 'integer', 'min:0'],
            'lead_time_days' => ['sometimes', 'nullable', 'integer', 'min:0'],
            'reorder_point'  => ['sometimes', 'nullable', 'integer', 'min:0'],
        ];
    }

    public function messages(): array
    {
        return [
            'min_stok.integer' => 'Minimal stok harus berupa angka.',
            'safety_stock.integer' => 'Safety stock harus berupa angka.',
            'lead_time_days.integer' => 'Lead time harus berupa angka.',
            'reorder_point.integer' => 'Reorder point harus berupa angka.',
        ];
    }
}