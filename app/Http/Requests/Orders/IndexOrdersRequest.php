<?php
namespace App\Http\Requests\Orders;

use Illuminate\Foundation\Http\FormRequest;

class IndexOrdersRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'cabang_id'     => ['nullable', 'integer'],
            'status'        => ['nullable', 'in:DRAFT,UNPAID,PAID,VOID,REFUND'],
            'cash_position' => ['nullable', 'in:CUSTOMER,CASHIER,SALES,ADMIN'],
            'date_from'     => ['nullable', 'date'],
            'date_to'       => ['nullable', 'date', 'after_or_equal:date_from'],

            'q'             => ['nullable', 'string', 'max:120'],
            'search'        => ['nullable', 'string', 'max:120'],

            'sort'          => ['nullable', 'in:ordered_at,-ordered_at,kode,-kode,grand_total,-grand_total'],
            'page'          => ['nullable', 'integer', 'min:1'],
            'per_page'      => ['nullable', 'integer', 'min:5', 'max:100'],
        ];
    }
}
